//
//  MediaFullscreenView.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 25/04/2022.
//

import UIKit

class MediaFullscreenView: UIView {

    private let zoomableImageView = ZoomableImageView()
    private let fullscreenNavigationView = FullscreenNavigationView()

    var onReturnButtonTap: (() -> Void)?
    var onEditButtonTap: ((UIImage) -> Void)?
    var onNavigationBarHiding: ((Bool) -> Void)?

    private var isHiddenNavigationBar = false {
        didSet {
            UIView.transition(with: self, duration: 0.1, options: [.transitionCrossDissolve]) { [weak self] in
                guard let self = self else { return }
                self.fullscreenNavigationView.isHidden = self.isHiddenNavigationBar
                self.onNavigationBarHiding?(self.isHiddenNavigationBar)
            }
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
        fullscreenNavigationView.isHidden = false
        zoomableImageView.setupImage(image: image)
    }
}

// MARK: - Add Views
private extension MediaFullscreenView {

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
        addSubview(fullscreenNavigationView)
        fullscreenNavigationView.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
        }
    }
}

// MARK: - Bind Elements
private extension MediaFullscreenView {
    
    func bind() {
        zoomableImageView.onDownSwipe = { [weak self] in
            self?.onReturnButtonTap?()
        }

        zoomableImageView.onSingleTap = { [weak self] in
            self?.isHiddenNavigationBar.toggle()
        }

        zoomableImageView.onScrollViewDidZoom = { [weak self] isZooming in
            self?.isHiddenNavigationBar = isZooming
        }

        fullscreenNavigationView.onReturnButtonTap = { [weak self] in
            self?.onReturnButtonTap?()
        }

        fullscreenNavigationView.onEditButtonTap = { [weak self] in
            guard let self = self,
                  let image = self.currentImage else { return }
            self.onEditButtonTap?(image)
        }
    }
}
