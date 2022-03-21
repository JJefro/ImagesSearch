//
//  PixabayModel.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 17/03/2022.
//

import Foundation

struct PixabayModel: Codable {
    let total: Int
    let totalHits: Int
    let hits: [Hit]
    
    struct Hit: Codable {
        let identifier: Int
        let type: String
        let tags: String
        let previewWidth, previewHeight: Int
        let webformatURL: String
        let webformatWidth, webformatHeight: Int
        let largeImageURL: String
        let imageWidth, imageHeight, imageSize, views: Int
        let downloads, collections, likes, comments: Int
        
        enum CodingKeys: String, CodingKey {
            case identifier = "id"
            case type, tags, previewWidth, previewHeight, webformatURL
            case webformatWidth, webformatHeight, largeImageURL, imageWidth, imageHeight, imageSize
            case views, downloads, collections, likes, comments
        }
    }
}
