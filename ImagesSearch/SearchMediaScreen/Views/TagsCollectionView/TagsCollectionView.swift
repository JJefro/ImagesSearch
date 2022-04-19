//
//  TagsCollectionView.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 17/03/2022.
//

import UIKit

class TagsCollectionView: UICollectionView {

    var onTagTap: ((Tag) -> Void)?

    private var tags: [Tag] = [] {
        didSet {
            reloadData()
        }
    }
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 8
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        super.init(frame: UIScreen.main.bounds, collectionViewLayout: flowLayout)
        configure()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTags(tags: [Tag]) {
        self.tags = tags
    }
}

private extension TagsCollectionView {
    func configure() {
        register(TagsCollectionViewCell.self, forCellWithReuseIdentifier: TagsCollectionViewCell.identifier)
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
    }
    
    func bind() {
        delegate = self
        dataSource = self
    }
}

extension TagsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: bounds.height)
    }
}

extension TagsCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onTagTap?(tags[indexPath.item])
    }
}

extension TagsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TagsCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let tag = tags[indexPath.row]
        cell.setupCell(data: tag)
        return cell
    }
}
