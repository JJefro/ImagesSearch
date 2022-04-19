//
//  BlurView.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 10/04/2022.
//

import Foundation
import UIKit

class BlurView: UIVisualEffectView {

    init() {
        var blur = UIBlurEffect()
        let lightBlur = UIBlurEffect(style: .extraLight)
        let darkBlur = UIBlurEffect(style: .dark)
        blur = UIScreen.main.traitCollection.userInterfaceStyle == .dark ? darkBlur : lightBlur
        super.init(effect: blur)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
