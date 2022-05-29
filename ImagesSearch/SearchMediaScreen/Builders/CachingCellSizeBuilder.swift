//
//  CachingCellSizeBuilder.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 29/04/2022.
//

import UIKit

class CachingCellSizeBuilder: CellSizeBuilderProtocol {

    private let builder: CellSizeBuilderProtocol

    private var cachedCellSizes: [String: CGSize] = [:]

    init(builder: CellSizeBuilderProtocol) {
        self.builder = builder
    }

    func calculateSize(for collectionView: UICollectionView, traitCollection: UITraitCollection) -> CGSize {
        let sizeString = "\(collectionView.frame.size)"
        if let cachedSize = cachedCellSizes[sizeString] {
            return cachedSize
        } else {
            let size = builder.calculateSize(for: collectionView, traitCollection: traitCollection)
            cachedCellSizes[sizeString] = size
            return size
        }
    }
}
