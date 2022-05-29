//
//  MediaCollectionsViewCell.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 19/03/2022.
//

import UIKit
import SDWebImage
import Photos

class MediaCollectionsViewCell: UICollectionViewCell {
    
    var onShareButtonTap: ((UIImage?) -> Void)?
    
    private let loadingView = LoadingView()
    private var placeholderImage = UIImage()
    private let shareButton = UIButton().apply {
        $0.setImage(R.image.share()?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = R.color.shareButtonTintColor()
        $0.backgroundColor = R.color.shareButtonBG()
        $0.layer.cornerRadius = 3
    }
    private let mediaImageView = UIImageView().apply {
        $0.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        configure()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(data: MediaContentModel, quality: MediaQuality, isHiddenShareButton: Bool) {
        shareButton.isHidden = isHiddenShareButton
        loadingView.isHidden = false
        mediaImageView.sd_setImage(
            with: getRequiredImageURL(data: data, quality: quality),
            placeholderImage: placeholderImage.sd_tintedImage(with: R.color.textColor()!)) { [weak self] (image, _, _, _) in
                guard let self = self else { return }
                self.mediaImageView.image = image
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.loadingView.isHidden = true
                }
            }
    }
    
    @objc func shareButtonTapped(_ sender: UIButton) {
        onShareButtonTap?(mediaImageView.image)
    }
    
    private func getRequiredImageURL(data: MediaContentModel, quality: MediaQuality) -> URL? {
        let imageURL: URL?
        switch quality {
        case .small:
            imageURL = data.smallImageURL
        case .normal:
            imageURL = data.normalImageURL
        case .large:
            imageURL = data.largeImageURL
        }
        return imageURL
    }
}

private extension MediaCollectionsViewCell {
    func addViews() {
        addMediaImageView()
        addShareButton()
        setPlaceholderImage()
        addLoadingView()
    }
    
    func configure() {
        clipsToBounds = true
        layer.cornerRadius = 5
    }
    
    func bind() {
        shareButton.addTarget(self, action: #selector(shareButtonTapped(_:)), for: .touchUpInside)
    }
    
    func addMediaImageView() {
        contentView.addSubview(mediaImageView)
        mediaImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func addShareButton() {
        contentView.addSubview(shareButton)
        shareButton.snp.makeConstraints {
            $0.trailing.top.equalTo(mediaImageView).inset(16)
            $0.size.equalTo(32)
        }
    }
    
    func addLoadingView() {
        contentView.addSubview(loadingView)
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setPlaceholderImage() {
        let image = R.image.pixabayLogo()?.withRenderingMode(.alwaysTemplate)
        guard var image = image else { return }
        image = image.resize(to: bounds.size)
        placeholderImage = image
    }
}
