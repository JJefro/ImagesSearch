//
//  SearchMediaViewController.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 14/03/2022.
//

import UIKit

class SearchMediaViewController: UIViewController {
    
    private var viewModel: SearchMediaViewModelProtocol
    private var contentView: SearchMediaViewProtocol
    
    init(contentView: SearchMediaViewProtocol, viewModel: SearchMediaViewModelProtocol) {
        self.contentView = contentView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardHideOnTappedAroundRecognizer()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setInterfaceOrientationMask(orientation: .all)
        viewModel.searchMedia()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        contentView.viewWillTransition()
    }
    
    private func shareImage(image: UIImage?) {
        guard let image = image?.jpegData(compressionQuality: 1) else { return }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = view
        self.present(activityController, animated: true, completion: nil)
    }

    private func showPixabayLicense() {
        guard let pixabayLicenseURL = viewModel.getLicenseURL() else { return }
        UIApplication.shared.open(pixabayLicenseURL)
    }
}

private extension SearchMediaViewController {
    
    func bind() {
        bindViewModel()
        bindContentView()
    }
    
    func bindViewModel() {
        viewModel.onStateChanges = { [weak self] state in
            guard let self = self else { return }
            switch state {
                
            case .onUpdateData(let data):
                self.contentView.setupSearchTextfieldText(text: self.viewModel.mediaData?.text)
                self.contentView.setTotalMediaContentLabel(text: data.totalMediaString)
                self.contentView.setupTagsCollectionView(tags: data.tags)
                self.contentView.setupMediaCollectionsView(mediaContents: data.mediaContents)
                
            case .onUpdateMediaContent(let mediaContents):
                self.contentView.setupMediaCollectionsView(mediaContents: mediaContents)
                
            case .onErrorOccured(let error):
                self.showAlert(
                    title: R.string.localizable.errorAlert_title(),
                    message: error.localizedDescription
                )
                
            case .onShowLoadingView(let isLoading):
                self.contentView.setLoadingView(isLoading: isLoading)
                
            case .onUpdateMediaQuality(let mediaQuality):
                self.contentView.updateMediaQuality(quality: mediaQuality)
            case .onUpdateCurrentSettings(let settingsData):
                self.contentView.setupSettings(settings: settingsData)
            }
        }
    }
    
    func bindContentView() {
        contentView.onStateChanges = { [weak self] state in
            guard let self = self else { return }
            switch state {
                
            case .onShareButtonTap(let image):
                self.shareImage(image: image)
                
            case .onTagTap(let tag):
                self.viewModel.filterMediaBy(tag: tag)
                
            case .onPixabayButtonTap:
                self.viewModel.showCurrentPixabayEntity()
                
            case .onGetSearchFieldValue(let text):
                guard let text = text else { return }
                self.viewModel.mediaData?.text = text
            case .onUpdateSettingsValue(let category, let quality):
                if let category = category {
                    self.viewModel.mediaData?.selectedCategory = category
                }
                if let quality = quality {
                    self.viewModel.updateMediaQuality(quality: quality)
                }
            case .onDownloadButtonTap(let image):
                guard let image = image else { return }
                self.saveImageToPhotoAlbum(image: image)
                
            case .onLicenseButtonTap:
                self.showPixabayLicense()
            }
        }
    }
}
