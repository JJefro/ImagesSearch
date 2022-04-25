//
//  CellSize.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 24/04/2022.
//

import UIKit

struct CellSettings {

    var landscapeOrientation: CellsCount
    var portraitOrientation: CellsCount

    struct CellsCount {
        var countPerScreen: CGFloat
        var countInRow: CGFloat
    }
}
