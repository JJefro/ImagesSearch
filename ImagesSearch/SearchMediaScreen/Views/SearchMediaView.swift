//
//  SearchMediaView.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 14/03/2022.
//

import UIKit

protocol SearchMediaViewProtocol: UIView {
    var onPixabayButtonTap: (() -> Void)? { get set }
    var onSettingsButtonTap: (() -> Void)? { get set }
    
    func setTotalMediaContentLabel(text: String?)
    func setLoadingView(isLoading: Bool)
    func setupTagsCollectionView(tags: [Tag]?)
    func setupMediaCollectionsView(mediaContents: [ImageContentModel])
    func setupSearchTextfieldText(text: String?)
}

class SearchMediaView: UIView, SearchMediaViewProtocol {
    var onPixabayButtonTap: (() -> Void)?
    var onSettingsButtonTap: (() -> Void)?
    
    private let topNavigationView = TopNavigationView()
    private let totalMediaLabel = UILabel()
    private let relatedLabel = UILabel()
    private let tagsCollectionView = TagsCollectionView()
    private let mediaCollectionView = MediaCollectionsView()
    private let loadingView = LoadingView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addViews()
        bind()
        loadingView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func pixabayButtonTapped(_ sender: UIButton) {
        onPixabayButtonTap?()
    }
    
    @objc private func settingsButttonTapped(_ sender: UIButton) {
        onSettingsButtonTap?()
    }
    
    func setTotalMediaContentLabel(text: String?) {
        totalMediaLabel.text = text
    }
    
    func setupTagsCollectionView(tags: [Tag]?) {
        tagsCollectionView.setupTags(tags: tags)
    }

    func setupMediaCollectionsView(mediaContents: [ImageContentModel]) {
        mediaCollectionView.setupMedia(contents: mediaContents)
    }

    func setupSearchTextfieldText(text: String?) {
        topNavigationView.searchView.searchField.txtField.text = text
    }
    
    func setLoadingView(isLoading: Bool) {
        loadingView.isHidden = !isLoading
    }
}

private extension SearchMediaView {
    func addViews() {
        addTopNavigationView()
        addTotalMediaContentLabel()
        addRelatedLabel()
        addTagsCollectionView()
        addMediaCollectionsView()
        addLoadingView()
    }
    
    func bind() {
        topNavigationView.pixabayButton.addTarget(
            self,
            action: #selector(pixabayButtonTapped(_:)),
            for: .touchUpInside
        )
        topNavigationView.settingsButton.addTarget(
            self,
            action: #selector(settingsButttonTapped(_:)),
            for: .touchUpInside
        )
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
            $0.leading.trailing.equalToSuperview().inset(16)
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
            $0.leading.trailing.equalToSuperview().inset(16)
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
        .preferredColorScheme(.light)
    }
}
#endif
#endif
