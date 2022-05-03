//
//  CellSizeBuilderProtocol.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 29/04/2022.
//

import UIKit

protocol CellSizeBuilderProtocol {
    func calculateSize(for collectionView: UICollectionView, traitCollection: UITraitCollection) -> CGSize
}
