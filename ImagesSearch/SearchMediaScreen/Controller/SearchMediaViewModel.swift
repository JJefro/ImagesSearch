//
//  SearchMediaViewModel.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 14/03/2022.
//

import Foundation

protocol SearchMediaViewModelProtocol {
    var mediaData: (text: String, category: MediaContents)? { get set }
    var onStateChanges: ((SearchMediaViewModel.State) -> Void)? { get set }
    
    func searchMedia()
}

class SearchMediaViewModel: SearchMediaViewModelProtocol {
  
    enum State {
        case onUpdateData(ContentEntityProtocol)
        case onErrorOccured(Error)
        case onShowLoadingView(Bool)
    }
    
    var onStateChanges: ((State) -> Void)?
    
    var mediaData: (text: String, category: MediaContents)?
    
    private var networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func searchMedia() {
        guard let mediaData = mediaData else { return }
        onStateChanges?(.onShowLoadingView(true))
        networkManager.searchMedia(by: mediaData.text, content: mediaData.category) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                self.onStateChanges?(.onUpdateData(data))
            case let .failure(error):
                self.onStateChanges?(.onErrorOccured(error))
            }
            self.onStateChanges?(.onShowLoadingView(false))
        }
    }
}
