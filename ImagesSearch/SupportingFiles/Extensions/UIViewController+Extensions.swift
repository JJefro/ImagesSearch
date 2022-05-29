//
//  UIViewController+Extensions.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 03/03/2022.
//

import UIKit
import Photos

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
    
    func showAlert(title: String?, message: String) {
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
        guard let appName = Bundle.main.appName else { return }
        let library = PHPhotoLibrary.shared()
        library.save(image: image, albumName: appName) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.showAlert(
                        title: R.string.localizable.alert_imageSaved_title(),
                        message: R.string.localizable.alert_imageSaved_message())
                } else {
                    self?.showAlert(
                        title: R.string.localizable.errorAlert_title(),
                        message: error?.localizedDescription ?? R.string.localizable.errorAlert_imageSavingFailed_title()
                    )
                }
            }
        }
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
