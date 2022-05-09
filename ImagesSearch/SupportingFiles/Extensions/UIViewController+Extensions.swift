//
//  UIViewController+Extensions.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 03/03/2022.
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
        endEditingTapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(endEditingTapRecognizer)
    }
    
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(
            title: R.string.localizable.errorAlert_action_title(),
            style: .cancel
        )
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }

    func saveImageToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(
                title: R.string.localizable.errorAlert_imageSavingFailed_title(),
                message: error.localizedDescription
            )
        } else {
            showAlert(
                title: R.string.localizable.alert_imageSaved_title(),
                message: R.string.localizable.alert_imageSaved_message()
            )
        }
    }

    func updateSizeClasses() -> UITraitCollection? {
        var customTrait = UITraitCollection()
        let widthCompact = UITraitCollection(horizontalSizeClass: .compact)
        let widthRegular = UITraitCollection(horizontalSizeClass: .regular)
        let heightRegular = UITraitCollection(verticalSizeClass: .regular)

        if traitCollection.userInterfaceIdiom == .pad {
            guard let orientation = getInterfaceOrientation() else { return nil }
            if orientation.isPortrait {
                customTrait = UITraitCollection(traitsFrom: [widthCompact, heightRegular])
            } else {
                if view.bounds.width < view.bounds.height {
                    customTrait = UITraitCollection(traitsFrom: [widthCompact, heightRegular])
                } else {
                    customTrait = UITraitCollection(traitsFrom: [widthRegular, heightRegular])
                }
            }
        }
        return customTrait
    }

    private func getInterfaceOrientation() -> UIInterfaceOrientation? {
        if #available(iOS 13, *) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
            return appDelegate.window?.windowScene?.interfaceOrientation
        } else {
            return UIApplication.shared.statusBarOrientation
        }
    }
}
