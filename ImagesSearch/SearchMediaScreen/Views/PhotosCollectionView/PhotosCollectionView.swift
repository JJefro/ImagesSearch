//
//  PhotosCollectionView.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 29/05/2022.
//

import UIKit
import Photos

class PhotosCollectionView: UICollectionView {

    var onZoomButtonTap: ((UIImage) -> Void)?

    private var fetchResult: PHFetchResult<PHAsset>? {
        didSet {
            reloadData()
        }
    }
    private let cellSizeBuilder: CellSizeBuilderProtocol
    private let flowLayout: UICollectionViewFlowLayout

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        flowLayout.invalidateLayout()
    }

    init(builder: CellSizeBuilderProtocol) {
        self.cellSizeBuilder = CachingCellSizeBuilder(builder: builder)
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = flowLayout.minimumLineSpacing
        super.init(frame: UIScreen.main.bounds, collectionViewLayout: flowLayout)
        configure()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupPhotos(result: PHFetchResult<PHAsset>) {
        fetchResult = result
    }
}

// MARK: - PhotosCollectionView Configurations
private extension PhotosCollectionView {
    func configure() {
        register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier)
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }

    func bind() {
        delegate = self
        dataSource = self
    }
}

// MARK: - Delegate FlowLayout Methods
extension PhotosCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSizeBuilder.calculateSize(for: self, traitCollection: traitCollection)
    }
}

// MARK: - DataSource Methods
extension PhotosCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fetchResult?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotosCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        guard let result = fetchResult else { return .init() }
        let asset = result.object(at: indexPath.item)
        cell.setupCell(asset: asset)
        cell.onZoomButtonTap = onZoomButtonTap
        return cell
    }
}
