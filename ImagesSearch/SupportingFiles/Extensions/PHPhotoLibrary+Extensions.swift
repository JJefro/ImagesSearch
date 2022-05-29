//
//  PHPhotoLibrary+Extensions.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 15/05/2022.
//

import Photos
import UIKit

extension PHPhotoLibrary {

    func save(image: UIImage, albumName: String?, completion: @escaping (Bool, Error?) -> Void) {
        func save() {
            if let albumName = albumName {
                getAlbum(named: albumName) { [weak self] album in
                    self?.saveImage(image: image, album: album, completion: completion)
                }
            } else {
                saveImage(image: image, album: nil, completion: completion)
            }
        }

        if PHPhotoLibrary.authorizationStatus() == .authorized {
            save()
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    save()
                }
            }
        }
    }

    func fetchAllPhotos() -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return PHAsset.fetchAssets(with: .image, options: fetchOptions)
    }
}

// MARK: - Private Methods
private extension PHPhotoLibrary {

    private func getAlbum(named: String, completion: @escaping (PHAssetCollection) -> Void) {
        if let album = findAlbum(named: named) {
            completion(album)
        } else {
            createAlbum(named: named, completion: completion)
        }
    }

    private func findAlbum(named: String) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", named)
        let fetchResult: PHFetchResult = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .any,
            options: fetchOptions
        )
        guard let photoAlbum = fetchResult.firstObject else {
            return nil
        }
        return photoAlbum
    }

    private func createAlbum(named: String, completion: @escaping (PHAssetCollection) -> Void) {
        var placeholder: PHObjectPlaceholder?
        performChanges({
            let createAlbumRequest = PHAssetCollectionChangeRequest
                .creationRequestForAssetCollection(withTitle: named)
            placeholder = createAlbumRequest.placeholderForCreatedAssetCollection
        }, completionHandler: { _, _ in
            let fetchResult = PHAssetCollection.fetchAssetCollections(
                withLocalIdentifiers: [placeholder!.localIdentifier],
                options: nil
            )
            completion(fetchResult.firstObject!)
        })
    }

    private func saveImage(image: UIImage, album: PHAssetCollection?, completion: @escaping (Bool, Error?) -> Void) {
        performChanges({
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            if let album = album {
                guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: album),
                      let photoPlaceholder = createAssetRequest.placeholderForCreatedAsset else { return }
                let fastEnumeration = NSArray(array: [photoPlaceholder] as [PHObjectPlaceholder])
                albumChangeRequest.addAssets(fastEnumeration)
            }
        }, completionHandler: { success, error in
            completion(success, error)
        })
    }
}
