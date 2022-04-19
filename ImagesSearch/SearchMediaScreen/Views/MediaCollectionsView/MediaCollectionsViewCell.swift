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
    private let imageView = UIImageView()
    private let shareButton = UIButton()
    private var placeHolderImage = UIImage()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addViews()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(data: MediaContentModel, quality: MediaQuality) {
        loadingView.isHidden = false
        let imageURL: URL?
        switch quality {
        case .small:
            imageURL = data.smallImageURL
        case .normal:
            imageURL = data.normalImageURL
        case .large:
            imageURL = data.largeImageURL
        }
        imageView.sd_setImage(
            with: imageURL,
            placeholderImage: placeHolderImage.sd_tintedImage(with: R.color.textColor()!)) { [weak self] (image, _, _, _) in
            guard let self = self else { return }
            if let image = image {
                self.imageView.image = image
                self.loadingView.isHidden = true
            }
        }
    }

    @objc func shareButtonTapped(_ sender: UIButton) {
        onShareButtonTap?(imageView.image)
    }
}

private extension MediaCollectionsViewCell {
    func addViews() {
        addImageView()
        addShareButton()
        addLoadingView()
        setPlaceholderImage()
    }

    func configure() {
        clipsToBounds = true
        layer.cornerRadius = 5
    }

    func bind() {
        shareButton.addTarget(self, action: #selector(shareButtonTapped(_:)), for: .touchUpInside)
    }

    func addImageView() {
        imageView.contentMode = .scaleAspectFill

        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func addShareButton() {
        let shareButtonImage = R.image.share()?.withRenderingMode(.alwaysTemplate)
        shareButton.setImage(shareButtonImage, for: .normal)
        shareButton.tintColor = R.color.shareButtonTintColor()
        shareButton.backgroundColor = R.color.shareButtonBG()
        shareButton.layer.cornerRadius = 3

        contentView.addSubview(shareButton)
        shareButton.snp.makeConstraints {
            $0.trailing.equalTo(imageView).inset(8)
            $0.top.equalTo(imageView).inset(8)
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
