//
//  DetailsViewModel.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 21/04/2022.
//

import UIKit

class DetailsViewModel {

    enum State {
        case onUpdateMediaContents([MediaContentModel], MediaContentModel, MediaQuality)
    }
    var onStateChanges: ((State) -> Void)?
    var previousSelectedMedia: MediaContentModel?

    func setupMediaContents(contents: [MediaContentModel], selectedMedia: MediaContentModel, quality: MediaQuality) {
        
        var mediaContents = contents
        if let previousMedia = previousSelectedMedia, let currentIndex = contents.firstIndex(of: selectedMedia) {
            mediaContents.insert(previousMedia, at: currentIndex)
        }
        mediaContents.removeAll(where: { $0 == selectedMedia })
        previousSelectedMedia = selectedMedia
        onStateChanges?(.onUpdateMediaContents(mediaContents, selectedMedia, quality))
    }
}
