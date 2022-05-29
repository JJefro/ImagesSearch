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
                likes: $0.likes,
                tags: $0.tags.components(separatedBy: ", ").map { Tag(rawValue: $0) }
            )
        }
        self.tags = getUniqueTagsFrom(data)
    }
    
    private func getUniqueTagsFrom(_ data: PixabayModel) -> [Tag] {
        let uniqueTags = Set(data.hits.map { $0.tags }.map { $0.components(separatedBy: ", ") }.joined())
        return Array(uniqueTags).map { Tag(rawValue: $0) }
    }

    private mutating func setupTags() {
        let uniqueTagsString = Set(mediaContents.map { $0.tags.map { $0.rawValue} }.joined())
        self.tags = uniqueTagsString.map { Tag(rawValue: $0) }
    }
}
