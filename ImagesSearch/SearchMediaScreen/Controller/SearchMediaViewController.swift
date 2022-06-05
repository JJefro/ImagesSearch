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
    private var isHiddenStatusBar = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
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
        viewModel.searchMedia()
        setInterfaceOrientationMask(orientation: .all)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if DeviceOrientation(traitCollection: traitCollection) == .pad {
            contentView.viewWillTransition()
        }
    }

    override var prefersStatusBarHidden: Bool {
        return isHiddenStatusBar
    }
}

// MARK: - Private Methods
private extension SearchMediaViewController {
    func shareImage(image: UIImage?) {
        guard let image = image?.jpegData(compressionQuality: 1) else {
            self.showAlert(
                title: R.string.localizable.errorAlert_title(),
                message: R.string.localizable.errorAlert_imageSharingFailed()
            )
            return
        }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = view
        self.present(activityController, animated: true, completion: nil)
    }

    func showPixabayLicense() {
        guard let pixabayLicenseURL = viewModel.getLicenseURL() else { return }
        UIApplication.shared.open(pixabayLicenseURL)
    }
}

private extension SearchMediaViewController {
    
    func bind() {
        bindViewModel()
        bindContentView()
    }

    // MARK: - Bind ViewModel
    func bindViewModel() {
        viewModel.onStateChanges = { [weak self] state in
            guard let self = self else { return }
            switch state {
                
            case .onUpdateMediaData(let data):
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
            case .onUpdatePhotosData(let fetchResult):
                self.contentView.setupPhotosCollectionView(result: fetchResult)
            }
        }
    }
    // MARK: - Bind ContentView
    // swiftlint:disable:next cyclomatic_complexity
    func bindContentView() {
        contentView.onStateChanges = { [weak self] state in
            guard let self = self else { return }
            switch state {
                
            case let .onShareButtonTap(image):
                self.shareImage(image: image)
                
            case let .onTagTap(tag):
                self.viewModel.filterMediaBy(tag: tag)
                
            case .onPixabayButtonTap:
                self.viewModel.showCurrentPixabayEntity()

            case let .onGetSearchFieldValue(text):
                guard let text = text else { return }
                self.viewModel.mediaData?.text = text
                
            case let .onUpdateSettingsValue(category, quality, mediaSource):
                if let category = category {
                    self.viewModel.mediaData?.selectedCategory = category
                }
                if let quality = quality {
                    self.viewModel.updateMediaQuality(quality: quality)
                }
                if let mediaSource = mediaSource {
                    self.viewModel.updateMediaSource(mediaSource: mediaSource)
                }
            case let .onDownloadButtonTap(image):
                guard let image = image else {
                    self.showAlert(
                        title: R.string.localizable.errorAlert_title(),
                        message: R.string.localizable.errorAlert_imageSavingFailed_title())
                    return
                }
                self.saveImageToPhotoAlbum(image: image)
            case .onLicenseButtonTap:
                self.showPixabayLicense()
            case let .onEditImageButtonTap(image):
                self.viewModel.onEditImageButtonTap?(image)
            case let .onHideMediaFullscreenNavigationBar(isHidden):
                self.isHiddenStatusBar = isHidden
            case .onHideMediaFullscreenView:
                self.isHiddenStatusBar = false
            }
        }
    }
}
