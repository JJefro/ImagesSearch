//
//  FullscreenView.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 25/04/2022.
//

import UIKit

class FullscreenView: UIView {

    private let zoomableImageView = ZoomableImageView()
    private let topNavigationView = FullscreenTopNavigationView()

    var onReturnButtonTap: (() -> Void)?
    var onEditButtonTap: ((UIImage) -> Void)?
    var onHideTopNavigationBar: ((Bool) -> Void)?

    private var isHiddenTopNavigationBar = false {
        didSet {
            UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve]) { [weak self] in
                guard let self = self else { return }
                self.topNavigationView.isHidden = self.isHiddenTopNavigationBar
            }
            onHideTopNavigationBar?(isHiddenTopNavigationBar)
        }
    }

    private var currentImage: UIImage?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = R.color.fullscreenBG()
        addViews()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupImage(image: UIImage?) {
        currentImage = image
        guard  let image = image  else { return }
        zoomableImageView.setupImage(image: image)
    }
}

private extension FullscreenView {

    func addViews() {
        addZoomableImageView()
        addTopNavigationView()
    }

    func addZoomableImageView() {
        addSubview(zoomableImageView)
        zoomableImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func addTopNavigationView() {
        addSubview(topNavigationView)
        topNavigationView.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
        }
    }
    
    func bind() {
        zoomableImageView.onDownSwipe = { [weak self] in
            self?.onReturnButtonTap?()
        }

        zoomableImageView.onSingleTap = { [weak self] in
            self?.isHiddenTopNavigationBar.toggle()
        }

        zoomableImageView.onScrollViewDidZoom = { [weak self] isZooming in
            self?.isHiddenTopNavigationBar = isZooming
        }

        topNavigationView.onReturnButtonTap = { [weak self] in
            self?.onReturnButtonTap?()
        }

        topNavigationView.onEditButtonTap = { [weak self] in
            guard let self = self,
                  let image = self.currentImage else { return }
            self.onEditButtonTap?(image)
        }
    }
}
