//
//  DetailsMediaContentCellSizeBuilder.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 29/04/2022.
//

import UIKit

class DetailsMediaContentCellSizeBuilder: CellSizeBuilderProtocol {
    
    let rows: [DeviceOrientation: CGFloat] = [
        .phonePortrait: 2,
        .phoneLandscape: 2,
        .pad: 2
        ]

    let columns: [DeviceOrientation: CGFloat] = [
        .phonePortrait: 2,
        .phoneLandscape: 2,
        .pad: 3
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
