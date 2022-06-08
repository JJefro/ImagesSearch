//
//  BlurView.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 10/04/2022.
//

import Foundation
import UIKit

class BlurView: UIVisualEffectView {

    private let lightBlur = UIBlurEffect(style: .extraLight)
    private let darkBlur = UIBlurEffect(style: .dark)

    init() {
        let blurEffect = UIScreen.main.traitCollection.userInterfaceStyle == .dark ? darkBlur : lightBlur
        super.init(effect: blurEffect)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        effect = getBlurEffect()
    }

    private func getBlurEffect() -> UIBlurEffect {
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return darkBlur
        case .light, .unspecified:
            return lightBlur
        @unknown default:
            return lightBlur
        }
    }
}
