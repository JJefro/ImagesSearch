//
//  CropMediaViewController.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 03/05/2022.
//

import UIKit
import TOCropViewController

class CropMediaViewController: TOCropViewController {

    var onDeinitTriggering: (() -> Void)?

    override init(croppingStyle style: TOCropViewCroppingStyle, image: UIImage) {
        switch style {
        case .default, .circular:
            super.init(croppingStyle: style, image: image)
        case .custom:
            super.init(
                image: image,
                toolbarButtonsBackgroundColor: R.color.gridOverlayLinesBackgroundColor()!,
                cropViewBackgroundColor: R.color.searchMediaViewBG()!
            )
        @unknown default:
            fatalError("croppingStyle has not been implemented")
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    deinit {
        onDeinitTriggering?()
    }

    func setup(contentView: UIView) {
        contentView.addSubview(view)
        view.frame = contentView.bounds
    }

    private func removeViewFromSubview() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

extension CropMediaViewController: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        saveToPhotos(image: image, completion: { [weak self] in
            self?.removeViewFromSubview()
        })
    }

    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        if cancelled {
            removeViewFromSubview()
        }
    }
}
