//
//  LoadingView.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 17/03/2022.
//

import UIKit
import NVActivityIndicatorView

class LoadingView: UIView {

    private var activityIndicator = NVActivityIndicatorView(
        frame: .zero,
        type: .ballClipRotateMultiple,
        color: UIScreen.main.traitCollection.userInterfaceStyle == .dark ? .white : .darkGray,
        padding: 0
    )

    private let blurView: UIVisualEffectView = {
        var blur = UIBlurEffect()
        let lightBlur = UIBlurEffect(style: .extraLight)
        let darkBlur = UIBlurEffect(style: .dark)
        blur = UIScreen.main.traitCollection.userInterfaceStyle == .dark ? darkBlur : lightBlur
        let blurView = UIVisualEffectView(effect: blur)
        return blurView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLoadingView()
        isHidden = false
    }

    override var isHidden: Bool {
        didSet {
            if isHidden {
                activityIndicator.stopAnimating()
            } else {
                activityIndicator.startAnimating()
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLoadingView() {
        self.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        makeActivityIndicatorConstraints()
    }

    private func makeActivityIndicatorConstraints() {
        self.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(self.snp.center)
            make.size.equalTo(60)
        }
    }
}
