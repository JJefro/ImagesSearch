//
//  ZoomableImageView.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 25/04/2022.
//

import UIKit

class ZoomableImageView: UIScrollView {

    var onDoubleTap: (() -> Void)?

    private let mediaImageView = UIImageView().apply {
        $0.backgroundColor = .black
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

    @objc func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        if zoomScale == 1 {
            onDoubleTap?()
        } else {
            setZoomScale(1, animated: true)
        }
    }
}

private extension ZoomableImageView {
    func addMediaImageView() {
        addSubview(mediaImageView)
        mediaImageView.snp.makeConstraints {
            $0.size.equalToSuperview()
            $0.center.equalToSuperview()
        }
    }

    func configure() {
        minimumZoomScale = 1
        maximumZoomScale = 10
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }

    func bind() {
        addDoubleTapRecognizer(view: mediaImageView)
        delegate = self
    }
}

private extension ZoomableImageView {
    func addDoubleTapRecognizer(view: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        tap.numberOfTapsRequired = 2
        addGestureRecognizer(tap)
    }
}

// MARK: - UIScrollView Delegate Methods
extension ZoomableImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mediaImageView
    }
}
