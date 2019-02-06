//
//  PDFDetailViewController.swift
//  Scan-app
//
//  Created by Emre Durukan on 23.12.2018.
//  Copyright © 2018 Emre Durukan. All rights reserved.
//

import UIKit
import PDFKit
import PDFGenerator

class PDFDetailViewController: UIViewController {

    @IBOutlet weak var pdfView: PDFView!
    var documents = [URL]()
    var pdfOrderNumber = 0
    var pdfTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button1 = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.exportButtonTapped))
        self.navigationItem.rightBarButtonItem = button1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        documents = Utilities.getDocuments()
        setPDF(pdfURL: documents[pdfOrderNumber])
        self.title = pdfTitle
    }
    
    func setPDF(pdfURL: URL) {
        if let pdfDocument = PDFDocument(url: pdfURL) {
            pdfView.displayMode = .singlePageContinuous
            pdfView.displayDirection = .vertical
            pdfView.document = pdfDocument
            pdfView.maxScaleFactor = 3.0
            pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit
            if let page = pdfDocument.page(at: 0) {
                let pageBounds = page.bounds(for: pdfView.displayBox)
                pdfView.scaleFactor = (pdfView.bounds.width) / pageBounds.width
            }
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
            print("document was not found")
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
                self.shareDocument(documentPath: self.documents[self.pdfOrderNumber].path)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            do {
                let filePath = self.documents[self.pdfOrderNumber]
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
}
