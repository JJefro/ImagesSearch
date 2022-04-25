//
//  TagsCollectionViewCell.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 17/03/2022.
//

import UIKit

class TagsCollectionViewCell: UICollectionViewCell {
    
    private let tagLabel = UILabel().apply {
        $0.textColor = R.color.textColor()
        $0.font = R.font.openSansRegular(size: 14)
        $0.textAlignment = .center
    }
    
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
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.center.equalToSuperview()
        }
    }
    
    func configure() {
        backgroundColor = R.color.tagsBG()
        clipsToBounds = true
        layer.cornerRadius = 5
    }
}
