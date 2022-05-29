//
//  PixabayEntity.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 17/03/2022.
//

import Foundation
import Photos

struct PixabayEntity {
    
    let totalMedia: Int
    let mediaCategory: MediaCategory?
    var tags: [Tag] = []
    var mediaContents: [MediaContentModel] = []
    
    var totalMediaString: String? {
        if let mediaCategory = mediaCategory?.rawValue {
            return [totalMedia.formattedWithSeparator, "Free", mediaCategory].joined(separator: " ")
        }
        return [totalMedia.formattedWithSeparator, "Photos"].joined(separator: " ")
    }
    
    init(data: PixabayModel) {
        guard let hits = data.hits.first else { fatalError() }
        self.totalMedia = data.total
        self.mediaCategory = MediaCategory(rawValue: hits.type.capitalized)
        self.mediaContents = data.hits.map {
            MediaContentModel(
                smallImageURL: URL(string: $0.previewURL),
                normalImageURL: URL(string: $0.webformatURL),
                largeImageURL: URL(string: $0.largeImageURL),
                image: nil,
                likes: $0.likes,
                tags: $0.tags.components(separatedBy: ", ").map { Tag(rawValue: $0) }
            )
        }
        self.tags = getUniqueTagsFrom(data)
    }

    init(assets: PHFetchResult<PHAsset>) {
        self.totalMedia = assets.count
        self.mediaCategory = nil
        self.setupMediaContents(assets: assets)
        self.setupTags()
    }
    
    private func getUniqueTagsFrom(_ data: PixabayModel) -> [Tag] {
        let uniqueTags = Set(data.hits.map { $0.tags }.map { $0.components(separatedBy: ", ") }.joined())
        return Array(uniqueTags).map { Tag(rawValue: $0) }
    }

    private mutating func setupMediaContents(assets: PHFetchResult<PHAsset>) {
        var mediaContentsModels: [MediaContentModel] = []
        for index in 0..<assets.count {
            let asset = assets.object(at: index)
            let imageManager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isSynchronous = true
            imageManager.requestImage(for: asset, targetSize: .zero, contentMode: .aspectFill, options: options) { image, _ in
                if let date = asset.creationDate {
                    mediaContentsModels.append(MediaContentModel(
                        smallImageURL: nil,
                        normalImageURL: nil,
                        largeImageURL: nil,
                        image: image,
                        likes: nil,
                        tags: [Tag(rawValue: String(describing: date.formattedWithMediumStyle))]
                    ))
                }
            }
        }
        self.mediaContents = mediaContentsModels
    }

    private mutating func setupTags() {
        let uniqueTagsString = Set(mediaContents.map { $0.tags.map { $0.rawValue} }.joined())
        self.tags = uniqueTagsString.map { Tag(rawValue: $0) }
    }
}
