//
//  SearchMediaView.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 14/03/2022.
//

import UIKit

protocol SearchMediaViewProtocol: UIView {
    var onStateChanges: ((SearchMediaView.State) -> Void)? { get set }
    var settingsData: [SettingsModel] { get set }

    func viewWillTransition()
    func setTotalMediaContentLabel(text: String?)
    func setLoadingView(isLoading: Bool)
    func setupTagsCollectionView(tags: [Tag])
    func setupMediaCollectionsView(mediaContents: [MediaContentModel])
    func setupSearchTextfieldText(text: String?)
    func updateMediaQuality(quality: MediaQuality)
}

class SearchMediaView: UIView, SearchMediaViewProtocol {

    enum State {
        case onPixabayButtonTap
        case onGetSearchFieldValue(String?)
        case onShareButtonTap(UIImage?)
        case onTagTap(Tag)
        case onUpdateSettingsValue(MediaCategory?, MediaQuality?)
    }

    var onStateChanges: ((State) -> Void)?
    
    private let topNavigationView = TopNavigationView()
    private var settingsView = SettingsView()
    private let totalMediaLabel = UILabel()
    private let relatedLabel = UILabel()
    private let tagsCollectionView = TagsCollectionView()
    private let mediaCollectionView = MediaCollectionsView()
    private let loadingView = LoadingView()

    var settingsData: [SettingsModel] = []
    
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
        mediaCollectionView.viewWillTransition()
    }
    
    @objc private func pixabayButtonTapped(_ sender: UIButton) {
        scrollToInitialValue()
        onStateChanges?(.onPixabayButtonTap)
    }
    
    @objc private func settingsButtonTapped(_ sender: UIButton) {
        settingsView.isShowSettingsView.toggle()
        settingsView.setupSettings(data: settingsData)
    }
    
    func setTotalMediaContentLabel(text: String?) {
        totalMediaLabel.text = text
    }
    
    func setupTagsCollectionView(tags: [Tag]) {
        tagsCollectionView.setupTags(tags: tags)
    }

    func setupMediaCollectionsView(mediaContents: [MediaContentModel]) {
        mediaCollectionView.mediaContents = mediaContents
    }

    func setupSearchTextfieldText(text: String?) {
        topNavigationView.searchView.searchField.txtField.text = text
    }
    
    func setLoadingView(isLoading: Bool) {
        loadingView.isHidden = !isLoading
    }

    func updateMediaQuality(quality: MediaQuality) {
        mediaCollectionView.mediaQuality = quality
    }

    private func scrollToInitialValue() {
        if !mediaCollectionView.mediaContents.isEmpty {
            let initialIndexPath: IndexPath = IndexPath(item: 0, section: 0)
            mediaCollectionView.scrollToItem(at: initialIndexPath, at: .top, animated: true)
            tagsCollectionView.scrollToItem(at: initialIndexPath, at: .left, animated: true)
        }
    }
}

private extension SearchMediaView {
    func addViews() {
        addTopNavigationView()
        addTotalMediaContentLabel()
        addRelatedLabel()
        addTagsCollectionView()
        addMediaCollectionsView()
        addSettingsView()
        addLoadingView()
    }

    func configure() {
        backgroundColor = R.color.searchMediaViewBG()
    }
    
    func bind() {
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
            self?.onStateChanges?(.onGetSearchFieldValue(text))
        }

        mediaCollectionView.onShareButtonTap = { [weak self] image in
            self?.onStateChanges?(.onShareButtonTap(image))
        }

        tagsCollectionView.onTagTap = { [weak self] tag in
            self?.onStateChanges?(.onTagTap(tag))
        }

        settingsView.onUpdateSettingsValue = { [weak self] (category, quality) in
            self?.onStateChanges?(.onUpdateSettingsValue(category, quality))
            self?.scrollToInitialValue()
        }
    }
    
    func addTopNavigationView() {
        topNavigationView.backgroundColor = backgroundColor
        addSubview(topNavigationView)
        topNavigationView.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
        }
    }
    
    func addTotalMediaContentLabel() {
        totalMediaLabel.textColor = R.color.textColor()
        totalMediaLabel.font = R.font.openSansSemiBold(size: 16)
        totalMediaLabel.textAlignment = .left
        
        addSubview(totalMediaLabel)
        totalMediaLabel.snp.makeConstraints {
            $0.top.equalTo(topNavigationView.snp.bottom)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).inset(6)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).inset(6)
        }
    }

    func addRelatedLabel() {
        relatedLabel.font = R.font.openSansRegular(size: 14)
        relatedLabel.textColor = R.color.grayTextColor()
        relatedLabel.text = R.string.localizable.searchMediaView_relatedLabel_text()

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
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).inset(16)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).inset(16)
            $0.bottom.equalToSuperview()
        }
    }

    func addSettingsView() {
        addSubview(settingsView)
        settingsView.snp.makeConstraints {
            $0.top.equalTo(topNavigationView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    func addLoadingView() {
        addSubview(loadingView)
        loadingView.snp.makeConstraints {
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
