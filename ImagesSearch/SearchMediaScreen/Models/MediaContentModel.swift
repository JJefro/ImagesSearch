//
//  MediaContentModel.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 20/03/2022.
//

import Foundation

struct MediaContentModel {
    let smallImageURL: URL?
    let normalImageURL: URL?
    let largeImageURL: URL?
    let likes: Int
    let tags: [Tag]
}
