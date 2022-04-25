//
//  MediaCollectionsViewCell.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 19/03/2022.
//

import UIKit
import SDWebImage

class MediaCollectionsViewCell: UICollectionViewCell {

    var onShareButtonTap: ((UIImage?) -> Void)?

    private let loadingView = LoadingView()
    private var placeHolderImage = UIImage()
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
        configure()
        addViews()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(data: MediaContentModel, quality: MediaQuality, isHiddenShareButton: Bool) {
        loadingView.isHidden = false
        shareButton.isHidden = isHiddenShareButton
        mediaImageView.sd_setImage(
            with: getRequiredImageURL(data: data, quality: quality),
            placeholderImage: placeHolderImage.sd_tintedImage(with: R.color.textColor()!)) { [weak self] (image, _, _, _) in
            guard let self = self else { return }
            if let image = image {
                self.mediaImageView.image = image
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
        addImageView()
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

    func addImageView() {
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
        placeHolderImage = image
    }
}
