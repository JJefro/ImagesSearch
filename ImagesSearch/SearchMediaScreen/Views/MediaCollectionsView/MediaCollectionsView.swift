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

    private var cellSizeOnIphone: CellSettings?
    private var cellSizeOnIpad: CellSettings?
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

    init() {
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

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        flowLayout.invalidateLayout()
    }

    func setupCellsCount(onIphone: CellSettings, onIpad: CellSettings) {
        self.cellSizeOnIphone = onIphone
        self.cellSizeOnIpad = onIpad
    }

    /// Need to change layout on iPad
    func viewWillTransition() {
        flowLayout.invalidateLayout()
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
    }

    func getFlowLayoutSizeForIpad() -> CGSize {
        var size = CGSize()
        guard let cellsCount = cellSizeOnIpad else { return size }
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            let cellsCountInRow = cellsCount.landscapeOrientation.countInRow
            let cellsPerScreen = cellsCount.landscapeOrientation.countPerScreen
            size = CGSize(
                width: (bounds.width - (flowLayout.minimumLineSpacing * (cellsCountInRow - 1))) / cellsCountInRow,
                height: (bounds.height - (flowLayout.minimumLineSpacing * (cellsPerScreen - 1))) / cellsPerScreen
            )
        default:
            let cellsCountInRow = cellsCount.portraitOrientation.countInRow
            let cellsPerScreen = cellsCount.portraitOrientation.countPerScreen
            size = CGSize(
                width: (bounds.width - (flowLayout.minimumLineSpacing * (cellsCountInRow - 1))) / cellsCountInRow,
                height: (bounds.height - (flowLayout.minimumLineSpacing * (cellsPerScreen - 1))) / cellsPerScreen
            )
        }
        return size
    }

    func getFlowLayoutSizeForIphone() -> CGSize {
        var size = CGSize()
        guard let cellsCount = cellSizeOnIphone else { return size }
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            let cellsCountInRow = cellsCount.landscapeOrientation.countInRow
            let cellsPerScreen = cellsCount.landscapeOrientation.countPerScreen
            size = CGSize(
                width: (bounds.width - flowLayout.minimumLineSpacing) / cellsCountInRow,
                height: (bounds.height - flowLayout.minimumLineSpacing) / cellsPerScreen
            )
        default:
            let cellsCountInRow = cellsCount.portraitOrientation.countInRow
            let cellsPerScreen = cellsCount.portraitOrientation.countPerScreen
            size = CGSize(
                width: (bounds.width - flowLayout.minimumLineSpacing) / cellsCountInRow,
                height: (bounds.height - flowLayout.minimumLineSpacing) / cellsPerScreen
            )
        }
        return size
    }
}

extension MediaCollectionsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize()
        if UIDevice.current.userInterfaceIdiom == .pad {
            size = getFlowLayoutSizeForIpad()
        } else {
            size = getFlowLayoutSizeForIphone()
        }
        return size
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
