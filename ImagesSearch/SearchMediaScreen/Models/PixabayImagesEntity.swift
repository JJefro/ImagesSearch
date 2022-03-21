//
//  PixabayEntity.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 17/03/2022.
//

import Foundation

protocol ContentEntityProtocol {
    var tags: [Tag]? { get set }
    var mediaContents: [ImageContentModel] { get set }
    var totalMediaString: String? { get }
}

struct PixabayImagesEntity: ContentEntityProtocol {
    
    let totalMedia: Int
    let mediaCategory: MediaCategory
    var tags: [Tag]?
    var mediaContents: [ImageContentModel]
    
    var totalMediaString: String? {
        guard let mediaCategory = mediaCategory.rawValue else { return nil }
        return [String(totalMedia), "Free", mediaCategory].joined(separator: " ")
    }
    
    init(data: PixabayModel) {
        self.totalMedia = data.total
        self.mediaCategory = MediaCategory(rawValue: data.hits.first?.type.capitalized)
        self.mediaContents = data.hits.map {
            ImageContentModel(
                imageURL: URL(string: $0.webformatURL),
                largeImageURL: URL(string: $0.largeImageURL),
                likes: $0.likes
            )
        }
        self.tags = getUniqueTagsFrom(data)
    }
    
    private func getUniqueTagsFrom(_ data: PixabayModel) -> [Tag] {
        let uniqueTags = Set(data.hits.map { $0.tags }.map { $0.components(separatedBy: ", ") }.joined())
        return Array(uniqueTags).map { Tag(rawValue: $0) }
    }
}
