//
//  TagsCollectionViewCell.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 17/03/2022.
//

import UIKit

class TagsCollectionViewCell: UICollectionViewCell {
    
    private let tagLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTagLabel()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
    }
    
    func setupCell(data: Tag) {
        tagLabel.text = data.rawValue
    }
}

private extension TagsCollectionViewCell {
    func addTagLabel() {
        tagLabel.textColor = R.color.textColor()
        tagLabel.font = R.font.openSansRegular(size: 14)
        tagLabel.textAlignment = .center
        
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.center.equalToSuperview()
        }
    }
    
    func configure() {
        backgroundColor = R.color.tagsBackgroundColor()
        clipsToBounds = true
        layer.cornerRadius = 5
    }
}
