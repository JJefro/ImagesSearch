//
//  PhotosCollectionContentCellSizeBuilder.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 06/06/2022.
//

import UIKit

class PhotosCollectionContentCellSizeBuilder: CellSizeBuilderProtocol {

    let rows: [DeviceOrientation: CGFloat] = [
        .phonePortrait: 10,
        .phoneLandscape: 3,
        .pad: 10
    ]
    let columns: [DeviceOrientation: CGFloat] = [
        .phonePortrait: 5,
        .phoneLandscape: 5,
        .pad: 10
    ]

    func calculateSize(for collectionView: UICollectionView, traitCollection: UITraitCollection) -> CGSize {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let frame = collectionView.frame
        let deviceOrientation = DeviceOrientation(traitCollection: traitCollection)
        let rows = self.rows[deviceOrientation, default: 1]
        let columns = self.columns[deviceOrientation, default: 1]
        let lineSpacing = layout?.minimumLineSpacing ?? 0
        let itemSpacing = layout?.minimumInteritemSpacing ?? 0
        let width = (frame.width - (itemSpacing * (columns - 1))) / columns
        let height = (frame.height - (lineSpacing * (rows - 1))) / rows
        return CGSize(width: width, height: height)
    }
}
