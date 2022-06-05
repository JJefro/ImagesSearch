//
//  PhotosCollectionViewCell.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 29/05/2022.
//

import UIKit
import Photos

class PhotosCollectionViewCell: UICollectionViewCell {

    var onZoomButtonTap: ((UIImage) -> Void)?

    private let photoImageView = UIImageView().apply {
        $0.contentMode = .scaleAspectFill
    }

    private let zoomButton = UIButton().apply {
        $0.setImage(R.image.plusMagnifyingglass()?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = R.color.shareButtonTintColor()
        $0.backgroundColor = R.color.shareButtonBG()
        $0.layer.cornerRadius = 3
    }

    private let imageManager = PHImageManager.default()
    private let requestImageOption = PHImageRequestOptions().apply {
        $0.deliveryMode = .highQualityFormat
    }
    private var currentImage: UIImage? {
        didSet {
            photoImageView.image = currentImage
        }
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

    func setupCell(asset: PHAsset) {
        getImageFromAsset(asset: asset)
    }
}

// MARK: - Private Methods
private extension PhotosCollectionViewCell {

    @objc func zoomButtonTapped(_ sender: UIButton) {
        guard let image = currentImage else { return }
        onZoomButtonTap?(image)
    }

    func getImageFromAsset(asset: PHAsset) {
        imageManager.requestImage(
            for: asset,
            targetSize: PHImageManagerMaximumSize,
            contentMode: .default,
            options: requestImageOption
        ) { [weak self] image, _  in
            self?.currentImage = image
        }
    }
}

// MARK: - Configurations
private extension PhotosCollectionViewCell {
    func configure() {
        clipsToBounds = true
        layer.cornerRadius = 5
    }

    func addViews() {
        addPhotoImageView()
        addZoomButton()
    }

    func bind() {
        zoomButton.addTarget(self, action: #selector(zoomButtonTapped(_:)), for: .touchUpInside)
    }
}

// MARK: - Adding Views
private extension PhotosCollectionViewCell {
    func addPhotoImageView() {
        contentView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func addZoomButton() {
        contentView.addSubview(zoomButton)
        zoomButton.snp.makeConstraints {
            $0.trailing.top.equalTo(photoImageView).inset(16)
            $0.size.equalTo(32)
        }
    }
}
