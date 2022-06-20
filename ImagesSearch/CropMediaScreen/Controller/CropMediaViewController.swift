//
//  CropMediaViewController.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 03/05/2022.
//

import UIKit
import TOCropViewController

class CropMediaViewController: TOCropViewController {

    init(croppingStyle style: TOCropViewCroppingStyle, image: UIImage) {
        super.init(
            croppingStyle: style,
            image: image,
            backgroundColor: R.color.searchMediaViewBG()!,
            overlayViewLinesColor: R.color.gridOverlayLinesBackgroundColor()!
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

private extension CropMediaViewController {
    func bind() {
        delegate = self
    }
}

extension CropMediaViewController: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        saveToPhotos(image: image)
        navigationController?.popViewController(animated: true)
    }
}
