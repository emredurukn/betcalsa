//
//  Album.swift
//  Scan-app
//
//  Created by Emre Durukan on 22.12.2018.
//  Copyright © 2018 Emre Durukan. All rights reserved.
//

import Foundation
import Photos

class MyAwesomeAlbum: NSObject {
    static let albumName = "Betcalsa"
    static let shared = MyAwesomeAlbum()
    
    private var assetCollection: PHAssetCollection!
    
    private override init() {
        super.init()
        
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }
    }
    
    private func checkAuthorizationWithHandler(completion: @escaping ((_ success: Bool) -> Void)) {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in
                self.checkAuthorizationWithHandler(completion: completion)
            })
        }
        else if PHPhotoLibrary.authorizationStatus() == .authorized {
            self.createAlbumIfNeeded { (success) in
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
                
            }
            
        }
        else {
            completion(false)
        }
    }
    
    private func createAlbumIfNeeded(completion: @escaping ((_ success: Bool) -> Void)) {
        if let assetCollection = fetchAssetCollectionForAlbum() {
            // Album already exists
            self.assetCollection = assetCollection
            completion(true)
        } else {
            PHPhotoLibrary.shared().performChanges({
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: MyAwesomeAlbum.albumName)   // create an asset collection with the album name
            }) { success, error in
                if success {
                    self.assetCollection = self.fetchAssetCollectionForAlbum()
                    completion(true)
                } else {
                    // Unable to create album
                    completion(false)
                }
            }
        }
    }
    
    private func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", MyAwesomeAlbum.albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let _: AnyObject = collection.firstObject {
            return collection.firstObject
        }
        return nil
    }
    
    func save(image: UIImage) {
        self.checkAuthorizationWithHandler { (success) in
            if success, self.assetCollection != nil {
                PHPhotoLibrary.shared().performChanges({
                    let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                    let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
                    if let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection) {
                        let enumeration: NSArray = [assetPlaceHolder!]
                        albumChangeRequest.addAssets(enumeration)
                    }
                    
                }, completionHandler: { (success, error) in
                    if success {
                        print("Success")
                    } else {
                        print("Error")
                    }
                })
            }
        }
    }
}
