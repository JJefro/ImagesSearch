//
//  MediaCollectionsView.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 19/03/2022.
//

import UIKit

class MediaCollectionsView: UICollectionView {

    private var mediaContents: [ImageContentModel]?

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 16
        super.init(frame: frame, collectionViewLayout: flowLayout)
        configure()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupMedia(contents: [ImageContentModel]) {
        self.mediaContents = contents
        reloadData()
    }
}

private extension MediaCollectionsView {
    func configure() {
        register(MediaCollectionsViewCell.self, forCellWithReuseIdentifier: MediaCollectionsViewCell.identifier)
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
    }

    func bind() {
        delegate = self
        dataSource = self
    }
}

extension MediaCollectionsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.width, height: 217)
    }
}

extension MediaCollectionsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let mediaContents = mediaContents else { return 0 }
        return mediaContents.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let mediaContents = mediaContents else { return .init() }
        let cell: MediaCollectionsViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let content = mediaContents[indexPath.row]
        cell.setupCell(data: content)
        return cell
    }
}
