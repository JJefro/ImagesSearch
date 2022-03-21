//
//  MediaCollectionsViewCell.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 19/03/2022.
//

import UIKit
import SDWebImage

class MediaCollectionsViewCell: UICollectionViewCell {

    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addImageView()
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(data: ImageContentModel) {
        imageView.sd_setImage(with: data.imageURL, placeholderImage: R.image.pixabayLogo())
    }
}

private extension MediaCollectionsViewCell {
    func addImageView() {
        imageView.contentMode = .scaleToFill

        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure() {
        clipsToBounds = true
        layer.cornerRadius = 5
    }
}
