//
//  MediaContentModel.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 20/03/2022.
//

import UIKit
import Photos

struct MediaContentModel: Equatable {
    static func == (lhs: MediaContentModel, rhs: MediaContentModel) -> Bool {
        lhs.smallImageURL == rhs.smallImageURL
    }

    let smallImageURL: URL?
    let normalImageURL: URL?
    let largeImageURL: URL?
    let likes: Int
    let tags: [Tag]
}
