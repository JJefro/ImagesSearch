//
//  FullscreenView.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 25/04/2022.
//

import UIKit

class FullscreenView: UIView {

    private let zoomableImageView = ZoomableImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        addZoomableImageView()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupImage(image: UIImage?) {
        if let image = image {
            zoomableImageView.setupImage(image: image)
            isHidden = false
        } else {
            isHidden = true
        }
    }
}

private extension FullscreenView {
    func addZoomableImageView() {
        addSubview(zoomableImageView)
        zoomableImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func bind() {
        zoomableImageView.onDoubleTap = { [weak self] in
            self?.isHidden = true
        }
    }
}
