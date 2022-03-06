//
//  UIViewController+Extensions.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 06/03/2022.
//

import UIKit

extension UIViewController {
    func setInterfaceOrientationMask(orientation: UIInterfaceOrientationMask) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.orientationLock = orientation
    }

    func addKeyboardHideOnTappedAroundRecognizer() {
        let endEditingTapRecognizer = UITapGestureRecognizer(
            target: view,
            action: #selector(UIView.endEditing)
        )
        view.addGestureRecognizer(endEditingTapRecognizer)
    }
}
