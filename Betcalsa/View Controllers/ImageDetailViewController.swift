//
//  ImageDetailViewController.swift
//  Scan-app
//
//  Created by Emre Durukan on 23.12.2018.
//  Copyright © 2018 Emre Durukan. All rights reserved.
//

import UIKit
import PDFGenerator

class ImageDetailViewController: UIViewController {
    
    var pictureOrderNumber = 0
    var documents = [URL]()
    var imageTitle = ""
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button1 = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.exportButtonTapped))
        self.navigationItem.rightBarButtonItem = button1
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        documents = Utilities.getDocuments()
        imageView.image = UIImage(contentsOfFile: documents[pictureOrderNumber].path)
        self.title = imageTitle
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            if let firstViewController = self.navigationController?.viewControllers.first {
                self.navigationController?.popToViewController(firstViewController, animated: true)
            }
        }))
        DispatchQueue.main.async {
            self.present(ac, animated: true)
        }
    }
    
    func shareDocument(documentPath: String) {
        if FileManager.default.fileExists(atPath: documentPath){
            let fileURL = URL(fileURLWithPath: documentPath)
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView=self.view
            present(activityViewController, animated: true, completion: nil)
        }
        else {
            print("Document was not found")
        }
    }

    @objc func exportButtonTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.dismiss(animated: true) {
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Share", style: .default, handler: { action in
            self.dismiss(animated: true) {
            }
            DispatchQueue.main.async {
                self.shareDocument(documentPath: self.documents[self.pictureOrderNumber].path)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Export to Photo Album", style: .default, handler: { action in
            if let image = UIImage(contentsOfFile: self.documents[self.pictureOrderNumber].path) {
                MyAwesomeAlbum.shared.save(image: image)
                self.showAlertWith(title: "Saved!", message: "Your image has been saved to your Photo Album.")
            }
            self.dismiss(animated: true) {
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Generate PDF", style: .default, handler: { action in
            var documentTitle = self.documents[self.pictureOrderNumber].path.components(separatedBy: "Documents/")[1]
            documentTitle = String(Array(documentTitle)[0..<(documentTitle.count-4)])
            let imagePath = self.documents[self.pictureOrderNumber].path
            self.generatePDF(imagePath: imagePath, pdfName: documentTitle)
            self.dismiss(animated: true) {
            }
        }))

        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            do {
                let filePath = self.documents[self.pictureOrderNumber]
                try FileManager.default.removeItem(at: filePath)
                
                if let firstViewController = self.navigationController?.viewControllers.first {
                    self.navigationController?.popToViewController(firstViewController, animated: true)
                }
            } catch {
                print("Delete error")
            }
        }))

        present(actionSheet, animated: true)
    }
    
    func generatePDF(imagePath: String, pdfName: String) {
        let page1 = PDFPage.imagePath(imagePath)
        let pages = [page1]
        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        docURL = docURL.appendingPathComponent("\(pdfName).pdf")
        
        do {
            try PDFGenerator.generate(pages, to: docURL, dpi: .dpi_300)
            showAlertWith(title: "Saved!", message: "Your image has been saved as PDF.")
        } catch (let e) {
            showAlertWith(title: "Save error", message: "Error saving as PDF.")
            print(e)
        }
    }

}

extension ImageDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
