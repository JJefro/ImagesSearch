//
//  SearchMediaView.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 14/03/2022.
//

import UIKit
import Photos

protocol SearchMediaViewProtocol: UIView {
    var onStateChanges: ((SearchMediaView.State) -> Void)? { get set }
    var totalMediaCount: Int { get set }

    func setTotalMediaContentLabel(text: String?)
    func setLoadingView(isLoading: Bool)
    func setupTagsCollectionView(tags: [Tag])
    func setupMediaCollectionsView(mediaContents: [MediaContentModel])
    func setupPhotosCollectionView(result: PHFetchResult<PHAsset>)
    func setupSearchTextfieldText(text: String?)
    func updateMediaQuality(quality: MediaQuality)
    func setupSettings(settings: [SettingsModel])
    func viewWillTransition()
}

class SearchMediaView: UIView, SearchMediaViewProtocol {
    enum State {
        case onPixabayButtonTap
        case onGetSearchFieldValue(String?)
        case onShareButtonTap(UIImage?)
        case onDownloadButtonTap(UIImage?)
        case onLicenseButtonTap
        case onTagTap(Tag)
        case onUpdateSettingsValue(MediaCategory?, MediaQuality?, MediaSource?)
        case onImageEdit(UIImage)
        case onMediaFullscreenNavigationBarHiding(Bool)
        case onMediaFullscreenViewHiding
    }

    private enum CurrentCollection {
        case photoCollectionView, mediaCollectionView
    }

    var onStateChanges: ((State) -> Void)?

    // MARK: - Views Configurations
    private let topNavigationView = TopNavigationView()
    private let totalMediaLabel = UILabel().apply {
        $0.textColor = R.color.textColor()
        $0.font = R.font.openSansSemiBold(size: 16)
        $0.textAlignment = .left
    }

    private let relatedLabel = UILabel().apply {
        $0.font = R.font.openSansRegular(size: 14)
        $0.textColor = R.color.grayTextColor()
        $0.text = R.string.localizable.searchMediaView_relatedLabel_text()
    }

    private let tagsCollectionView = TagsCollectionView()
    private let mediaCollectionView = MediaCollectionsView(
        builder: MediaCollectionContentCellSizeBuilder()
    )
    private let photosCollectionView = PhotosCollectionView(
        builder: PhotosCollectionContentCellSizeBuilder()).apply {
        $0.isHidden = true
    }
    private var settingsView = SettingsView()
    private let loadingView = LoadingView()
    private let detailsView = DetailsView().apply {
        $0.isHidden = true
    }
    private let mediaFullscreenView = MediaFullscreenView().apply {
        $0.isHidden = true
    }

    private var currentCollectionView: CurrentCollection = .mediaCollectionView {
        didSet {
            changeCurrentCollectionView()
        }
    }

    var totalMediaCount = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        configure()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func viewWillTransition() {
        detailsView.setNeedsUpdateConstraints()
    }
}

// MARK: - Methods
extension SearchMediaView {
    func setTotalMediaContentLabel(text: String?) {
        totalMediaLabel.text = text
    }

    func setupTagsCollectionView(tags: [Tag]) {
        tagsCollectionView.setupTags(tags: tags)
    }

    func setupMediaCollectionsView(mediaContents: [MediaContentModel]) {
        mediaCollectionView.mediaContents = mediaContents
        currentCollectionView = .mediaCollectionView
        scrollToInitialValue()
    }

    func setupPhotosCollectionView(result: PHFetchResult<PHAsset>) {
        photosCollectionView.setupPhotos(result: result)
        currentCollectionView = .photoCollectionView
    }

    func setupSearchTextfieldText(text: String?) {
        topNavigationView.searchView.searchField.txtField.text = text
    }

    func setLoadingView(isLoading: Bool) {
        loadingView.isHidden = !isLoading
    }

    func updateMediaQuality(quality: MediaQuality) {
        mediaCollectionView.mediaQuality = quality
        detailsView.updateMediaQuality(quality: quality)
    }

    func setupSettings(settings: [SettingsModel]) {
        settingsView.setupSettings(data: settings)
    }
}

// MARK: - Private Methods
private extension SearchMediaView {
    @objc func pixabayButtonTapped(_ sender: UIButton) {
        if !detailsView.isHidden {
            showDetailsView(isShown: false)
        }
        if currentCollectionView == .photoCollectionView || mediaCollectionView.mediaContents.count < totalMediaCount || mediaCollectionView.mediaContents.isEmpty {
            onStateChanges?(.onPixabayButtonTap)
        }
        scrollToInitialValue()
    }

    @objc func settingsButtonTapped(_ sender: UIButton) {
        settingsView.isShowSettingsView.toggle()
    }

    func scrollToInitialValue() {
        if !mediaCollectionView.mediaContents.isEmpty {
            let initialIndexPath: IndexPath = IndexPath(item: 0, section: 0)
            mediaCollectionView.scrollToItem(at: initialIndexPath, at: .top, animated: true)
            tagsCollectionView.scrollToItem(at: initialIndexPath, at: .left, animated: true)
        }
    }

    func showDetailsView(isShown: Bool) {
        UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve]) { [weak self] in
            guard let self = self else { return }
            self.detailsView.isHidden = !isShown
        }
    }

    func showMediaFullscreenView(isShown: Bool) {
        UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve]) {
            self.mediaFullscreenView.isHidden = !isShown
        }
    }

    func changeCurrentCollectionView() {
        switch currentCollectionView {
        case .mediaCollectionView:
            mediaCollectionView.isHidden = false
            tagsCollectionView.isHidden = false
            relatedLabel.isHidden = false
            totalMediaLabel.isHidden = false
            photosCollectionView.isHidden = true
        case .photoCollectionView:
            mediaCollectionView.isHidden = true
            tagsCollectionView.isHidden = true
            relatedLabel.isHidden = true
            totalMediaLabel.isHidden = true
            photosCollectionView.isHidden = false
            detailsView.isHidden = true
        }
    }
}

// MARK: - Bind Elements
private extension SearchMediaView {
    func bind() {
        bindTopNavigationView()
        bindMediaCollectionView()
        bindPhotosCollectionView()
        bindTagsCollectionView()
        bindSettingsView()
        bindDetailsView()
        bindFullscreenView()
    }

    func bindTopNavigationView() {
        topNavigationView.pixabayButton.addTarget(
            self,
            action: #selector(pixabayButtonTapped(_:)),
            for: .touchUpInside
        )
        topNavigationView.settingsButton.addTarget(
            self,
            action: #selector(settingsButtonTapped(_:)),
            for: .touchUpInside
        )

        topNavigationView.searchView.onGetSearchFieldValue = { [weak self] text in
            self?.showDetailsView(isShown: false)
            self?.onStateChanges?(.onGetSearchFieldValue(text))
        }
    }

    func bindMediaCollectionView() {
        mediaCollectionView.onShareButtonTap = { [weak self] image in
            self?.onStateChanges?(.onShareButtonTap(image))
        }

        mediaCollectionView.onCellTap = { [weak self] (mediaContents, selectedMedia, quality) in
            guard let self = self else { return }
            self.detailsView.setupMediaContents(
                mediaContents: mediaContents,
                selected: selectedMedia,
                quality: quality)
            self.showDetailsView(isShown: true)
        }
    }

    func bindPhotosCollectionView() {
        photosCollectionView.onZoomButtonTap = { [weak self] image in
            guard let self = self else { return }
            self.showMediaFullscreenView(isShown: true)
            self.mediaFullscreenView.setupImage(image: image)
        }
    }

    func bindTagsCollectionView() {
        tagsCollectionView.onTagTap = { [weak self] tag in
            self?.onStateChanges?(.onTagTap(tag))
        }
    }

    func bindSettingsView() {
        settingsView.onUpdateSettingsValue = { [weak self] (category, quality, mediaSource) in
            self?.onStateChanges?(.onUpdateSettingsValue(category, quality, mediaSource))
            self?.scrollToInitialValue()
        }
    }

    func bindDetailsView() {
        detailsView.onSelectedMediaViewStateChanges = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case let .onShareButtonTap(image):
                self.onStateChanges?(.onShareButtonTap(image))
            case let .onDownloadButtonTap(image):
                self.onStateChanges?(.onDownloadButtonTap(image))
            case .onLicenseButtonTap:
                self.onStateChanges?(.onLicenseButtonTap)
            case let .onZoomButtonTap(image):
                self.showMediaFullscreenView(isShown: true)
                self.mediaFullscreenView.setupImage(image: image)
            case let .onCropButtonTap(image):
                self.onStateChanges?(.onImageEdit(image))
            }
        }
    }

    func bindFullscreenView() {
        mediaFullscreenView.onReturnButtonTap = { [weak self] in
            self?.onStateChanges?(.onMediaFullscreenViewHiding)
            self?.showMediaFullscreenView(isShown: false)
        }
        mediaFullscreenView.onEditButtonTap = { [weak self] image in
            self?.onStateChanges?(.onImageEdit(image))
        }
        mediaFullscreenView.onNavigationBarHiding = { [weak self] isHidden in
            self?.onStateChanges?(.onMediaFullscreenNavigationBarHiding(isHidden))
        }
    }
}

// MARK: - Add Views and Configurations
private extension SearchMediaView {
    func addViews() {
        addTopNavigationView()
        addTotalMediaContentLabel()
        addRelatedLabel()
        addTagsCollectionView()
        addMediaCollectionsView()
        addPhotosCollectionView()
        addDetailsView()
        addLoadingView()
        addSettingsView()
        addZoomableImageView()
    }

    func configure() {
        backgroundColor = R.color.searchMediaViewBG()
    }

    func addTopNavigationView() {
        addSubview(topNavigationView)
        topNavigationView.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
        }
    }

    func addTotalMediaContentLabel() {
        addSubview(totalMediaLabel)
        totalMediaLabel.snp.makeConstraints {
            $0.top.equalTo(topNavigationView.snp.bottom)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(6)
        }
    }

    func addRelatedLabel() {
        addSubview(relatedLabel)
        relatedLabel.snp.makeConstraints {
            $0.top.equalTo(totalMediaLabel.snp.bottom)
            $0.leading.equalTo(totalMediaLabel.snp.leading)
            $0.height.equalTo(30)
            $0.width.equalTo(66)
        }
    }

    func addTagsCollectionView() {
        addSubview(tagsCollectionView)
        tagsCollectionView.snp.makeConstraints {
            $0.top.equalTo(totalMediaLabel.snp.bottom)
            $0.leading.equalTo(relatedLabel.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(relatedLabel.snp.height)
        }
    }

    func addMediaCollectionsView() {
        addSubview(mediaCollectionView)
        mediaCollectionView.snp.makeConstraints {
            $0.top.equalTo(tagsCollectionView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            $0.bottom.equalToSuperview()
        }
    }

    func addPhotosCollectionView() {
        addSubview(photosCollectionView)
        photosCollectionView.snp.makeConstraints {
            $0.top.equalTo(topNavigationView.snp.bottom)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            $0.bottom.equalToSuperview()
        }
    }

    func addSettingsView() {
        addSubview(settingsView)
        settingsView.snp.makeConstraints {
            $0.top.equalTo(topNavigationView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    func addDetailsView() {
        addSubview(detailsView)
        detailsView.snp.makeConstraints {
            $0.top.equalTo(topNavigationView.snp.bottom)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }

    func addLoadingView() {
        addSubview(loadingView)
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func addZoomableImageView() {
        addSubview(mediaFullscreenView)
        mediaFullscreenView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Preview Provider
#if DEBUG
#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, *)
struct SearchMediaViewRepresentation: UIViewRepresentable {
    func makeUIView(context: Context) -> SearchMediaView {
        return SearchMediaView()
    }

    func updateUIView(_ uiView: SearchMediaView, context: Context) {}
}

@available(iOS 13, *)
struct SearchMediaViewRepresentablePreview: PreviewProvider {
    static var previews: some View {
        Group {
            SearchMediaViewRepresentation()
        }
        .preferredColorScheme(.dark)
    }
}
#endif
#endif
