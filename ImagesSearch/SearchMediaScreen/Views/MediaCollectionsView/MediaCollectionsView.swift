//
//  MediaCollectionsView.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 19/03/2022.
//

import UIKit

class MediaCollectionsView: UICollectionView {

    var onShareButtonTap: ((UIImage?) -> Void)?

    private let cellsPerScreen: CGFloat = 3                                                    /// Cells count per screen in Portrait orientation.
    private let cellsCountInRow: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2 /// Cells count in row on iPad : iPhone in Landscape orientation.
    private let flowLayout: UICollectionViewFlowLayout

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
}

extension MediaCollectionsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var size = CGSize()
        if UIDevice.current.userInterfaceIdiom == .pad {
            size = CGSize(
                width: (bounds.width - (flowLayout.minimumLineSpacing * (cellsCountInRow - 1))) / cellsCountInRow,
                height: (bounds.height - flowLayout.minimumLineSpacing) / cellsPerScreen
            )
        } else {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                size = CGSize(
                    width: (bounds.width - flowLayout.minimumLineSpacing) / cellsCountInRow,
                    height: bounds.height - flowLayout.minimumLineSpacing * cellsCountInRow
                )
            default:
                size = CGSize(
                    width: bounds.width,
                    height: bounds.height / cellsPerScreen
                )
            }
        }
        return size
    }
}

extension MediaCollectionsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaContents.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MediaCollectionsViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let content = mediaContents[indexPath.row]
        cell.setupCell(data: content, quality: mediaQuality)
        cell.onShareButtonTap = onShareButtonTap
        return cell
    }
}
