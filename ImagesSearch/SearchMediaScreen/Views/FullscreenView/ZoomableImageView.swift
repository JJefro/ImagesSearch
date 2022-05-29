//
//  ZoomableImageView.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 25/04/2022.
//

import UIKit

class ZoomableImageView: UIScrollView {

    var onDownSwipe: (() -> Void)?
    var onScrollViewDidZoom: ((Bool) -> Void)?
    var onSingleTap: (() -> Void)?

    private var singleTapGesture = UITapGestureRecognizer()
    private var doubleTapGesture = UITapGestureRecognizer()

    private let mediaImageView = UIImageView().apply {
        $0.contentMode = .scaleAspectFit
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addMediaImageView()
        configure()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupImage(image: UIImage) {
        mediaImageView.image = image
    }
}

private extension ZoomableImageView {
    func addMediaImageView() {
        addSubview(mediaImageView)
        mediaImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.edges.equalToSuperview()
        }
    }

    func configure() {
        minimumZoomScale = 1
        maximumZoomScale = 10
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }

    func bind() {
        addSingleTapRecognizer(view: mediaImageView)
        addDoubleTapRecognizer(view: mediaImageView)
        addDownSwipeGesture(view: self)
        delegate = self
    }
}

// MARK: - Gesture Recognizers
private extension ZoomableImageView {
    func addSingleTapRecognizer(view: UIView) {
        singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.require(toFail: doubleTapGesture)
        addGestureRecognizer(singleTapGesture)
    }

    @objc func handleSingleTap(_ sender: UITapGestureRecognizer) {
        if zoomScale == 1 {
            onSingleTap?()
        }
    }

    func addDoubleTapRecognizer(view: UIView) {
        doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.require(toFail: singleTapGesture)
        addGestureRecognizer(doubleTapGesture)
    }

    @objc func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        if zoomScale == 1 {
            setZoomScale(5, animated: true)
        } else {
            setZoomScale(1, animated: true)
        }
    }

    func addDownSwipeGesture(view: UIView) {
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleDownSwipe(_:)))
        downSwipe.direction = .down
        view.addGestureRecognizer(downSwipe)
    }

    @objc func handleDownSwipe(_ sender: UISwipeGestureRecognizer) {
        onDownSwipe?()
    }
}

// MARK: - UIScrollView Delegate Methods
extension ZoomableImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mediaImageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        onScrollViewDidZoom?(true)
    }
}
