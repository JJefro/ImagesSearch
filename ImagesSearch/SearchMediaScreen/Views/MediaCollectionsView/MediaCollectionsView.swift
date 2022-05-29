//
//  MediaCollectionsView.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 19/03/2022.
//

import UIKit

class MediaCollectionsView: UICollectionView {

    var onShareButtonTap: ((UIImage?) -> Void)?
    var onCellTap: (([MediaContentModel], MediaContentModel, MediaQuality) -> Void)?

    private let cellSizeBuilder: CellSizeBuilderProtocol

    private let flowLayout: UICollectionViewFlowLayout

    var isHiddenShareButton: Bool = false {
        didSet {
            reloadData()
        }
    }

    var mediaQuality: MediaQuality = .normal {
        didSet {
            reloadData()
        }
    }
    
    var mediaContents: [MediaContentModel] = [] {
        didSet {
            reloadData()
        }
    }

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
}

private extension MediaCollectionsView {
    func configure() {
        register(MediaCollectionsViewCell.self, forCellWithReuseIdentifier: MediaCollectionsViewCell.identifier)
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }

    func bind() {
        delegate = self
        dataSource = self
        addObserverToNotificationCenter()
    }

    func addObserverToNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleOrientationChanges(notification:)),
            name: UIDevice.orientationDidChangeNotification,
            object: nil)
    }

    @objc func handleOrientationChanges(notification: Notification) {
        if notification.name == UIDevice.orientationDidChangeNotification {
            flowLayout.invalidateLayout()
        }
    }
}

extension MediaCollectionsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSizeBuilder.calculateSize(for: self, traitCollection: traitCollection)
    }
}

extension MediaCollectionsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mediaObject = mediaContents[indexPath.row]
        onCellTap?(mediaContents, mediaObject, mediaQuality)
    }
}

extension MediaCollectionsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaContents.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MediaCollectionsViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let content = mediaContents[indexPath.row]
        cell.setupCell(data: content, quality: mediaQuality, isHiddenShareButton: isHiddenShareButton)
        cell.onShareButtonTap = onShareButtonTap
        return cell
    }
}
