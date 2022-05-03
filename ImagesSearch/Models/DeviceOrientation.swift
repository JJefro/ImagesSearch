//
//  DeviceOrientation.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 28/04/2022.
//

import UIKit

enum DeviceOrientation {
    case phonePortrait
    case phoneLandscape
    case pad
    
    init(traitCollection: UITraitCollection) {
        switch traitCollection.userInterfaceIdiom {
        case .phone:
            switch (traitCollection.horizontalSizeClass, traitCollection.verticalSizeClass) {
            case (.compact, .regular):
                self = .phonePortrait
            default:
                self = .phoneLandscape
            }
        case .pad:
            self = .pad
        default:
            fatalError("Not implemented")
        }
    }
}
