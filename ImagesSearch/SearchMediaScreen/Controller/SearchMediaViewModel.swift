//
//  SearchMediaViewModel.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 14/03/2022.
//

import UIKit
import Photos

protocol SearchMediaViewModelProtocol {
    var mediaData: (text: String, selectedCategory: MediaCategory)? { get set }
    var onStateChanges: ((SearchMediaViewModel.State) -> Void)? { get set }
    var onImageEdit: ((UIView, UIImage) -> Void)? { get set }
    
    func searchMedia()
    func filterMediaBy(tag: Tag)
    func showCurrentPixabayEntity()
    func updateMedia(quality: MediaQuality)
    func updateMedia(source: MediaSource)
    func updateMediaSettings()
    func getLicenseURL() -> URL?
}

class SearchMediaViewModel: SearchMediaViewModelProtocol {
    
    enum State {
        case onUpdateMediaData(PixabayEntity)
        case onUpdatePhotosData(PHFetchResult<PHAsset>)
        case onUpdateMediaContent([MediaContentModel])
        case onUpdateMediaQuality(MediaQuality)
        case onUpdateCurrentSettings([SettingsModel])
        case onErrorOccured(Error)
        case onShowLoadingView(Bool)
    }
    
    var onStateChanges: ((State) -> Void)?
    var onImageEdit: ((UIView, UIImage) -> Void)?
    var mediaData: (text: String, selectedCategory: MediaCategory)? {
        didSet {
            currentMediaSource = .remote
        }
    }
    
    private(set) var categoryList: [MediaCategory] = []
    private var pixabayEntity: PixabayEntity? {
        didSet {
            guard let entity = pixabayEntity else { return }
            onStateChanges?(.onUpdateMediaData(entity))
        }
    }
    
    private var currentMediaQuality: MediaQuality = .normal {
        didSet {
            onStateChanges?(.onUpdateMediaQuality(currentMediaQuality))
        }
    }
    
    private var currentMediaSource: MediaSource = .remote {
        didSet {
            updateMediaSettings()
            if currentMediaSource == .local {
                fetchLocalPhotos()
            } else {
                searchMedia()
            }
        }
    }

    private var currentMediaContent: [MediaContentModel] = [] {
        didSet {
            onStateChanges?(.onUpdateMediaContent(currentMediaContent))
        }
    }
    
    private var networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func getLicenseURL() -> URL? {
        return Contstants.pixabayLicenseURLComponents.url
    }
    
    func setupMediaCategories(list: [MediaCategory]) {
        categoryList = list
    }
    
    func searchMedia() {
        guard let mediaData = mediaData else { return }
        onStateChanges?(.onShowLoadingView(true))
        updateMediaSettings()
        networkManager.searchMedia(by: mediaData.text, category: mediaData.selectedCategory) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(entity):
                self.pixabayEntity = entity
            case let .failure(error):
                self.onStateChanges?(.onErrorOccured(error))
            }
            self.onStateChanges?(.onShowLoadingView(false))
        }
    }
    
    func fetchLocalPhotos() {
        let library = PHPhotoLibrary.shared()
        let fetchResult = library.fetchAllPhotos()
        onStateChanges?(.onUpdatePhotosData(fetchResult))
    }
    
    func filterMediaBy(tag: Tag) {
        guard let mediaContent = pixabayEntity?.mediaContents else { return }
        let filteredMedia = mediaContent.filter { $0.tags.contains(where: { $0 == tag }) }
        onStateChanges?(.onUpdateMediaContent(filteredMedia))
    }
    
    func showCurrentPixabayEntity() {
        if let entity = pixabayEntity {
            currentMediaSource = .remote
            onStateChanges?(.onUpdateMediaData(entity))
        } else {
            searchMedia()
        }
    }
    
    func updateMedia(quality: MediaQuality) {
        self.currentMediaQuality = quality
    }
    
    func updateMedia(source: MediaSource) {
        self.currentMediaSource = source
    }
    
    func updateMediaSettings() {
        guard let mediaData = mediaData else { return }
        var settings: [SettingsModel] = []

        if currentMediaSource == .remote {
        let mediaCategorySettings = SettingsModel(
            title: R.string.localizable.settingsView_mediaCategoryTitle(),
            selectedItem: mediaData.selectedCategory.rawValue,
            pickerValues: categoryList.map { $0.rawValue }
        )
        let mediaQualitySettings = SettingsModel(
            title: R.string.localizable.settingsView_mediaSizeTitle(),
            selectedItem: currentMediaQuality.rawValue,
            pickerValues: MediaQuality.allCases.map { $0.rawValue }
        )
            settings.append(contentsOf: [mediaCategorySettings, mediaQualitySettings])
        }
        let mediaSource = SettingsModel(
            title: R.string.localizable.settingsView_mediaSourceTitle(),
            selectedItem: currentMediaSource.rawValue,
            pickerValues: MediaSource.allCases.map { $0.rawValue }
        )
        settings.append(mediaSource)
        onStateChanges?(.onUpdateCurrentSettings(settings))
    }
}
