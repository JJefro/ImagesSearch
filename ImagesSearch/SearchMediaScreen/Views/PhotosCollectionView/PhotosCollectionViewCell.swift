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

    private let imageManager = PHImageManager.default()
    private let highQualityImageOption = PHImageRequestOptions().apply {
        $0.version = .original
        $0.deliveryMode = .highQualityFormat
    }
    private let fastFormatImageOption = PHImageRequestOptions().apply {
        $0.deliveryMode = .fastFormat
    }
    private var currentAsset: PHAsset? {
        didSet {
            getImageFromAsset(
                asset: currentAsset,
                with: fastFormatImageOption) { [weak self] image in
                    self?.photoImageView.image = image
                }
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
        currentAsset = asset
    }
}

// MARK: - Private Methods
private extension PhotosCollectionViewCell {

    @objc func cellTapped(_ sender: UITapGestureRecognizer) {
        getImageFromAsset(
            asset: currentAsset,
            with: highQualityImageOption) { [weak self] image in
                guard let image = image else { return }
                self?.onZoomButtonTap?(image)
            }
    }

    func addTapGestureRecognizer(view: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
        tap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tap)
    }

    func getImageFromAsset(asset: PHAsset?,
                           with options: PHImageRequestOptions,
                           completion: @escaping (UIImage?) -> Void) {
        guard let asset = asset else { return }
        imageManager.requestImage(
            for: asset,
            targetSize: PHImageManagerMaximumSize,
            contentMode: .default,
            options: options
        ) { image, _  in
            completion(image)
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
    }

    func bind() {
        addTapGestureRecognizer(view: self)
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
}
