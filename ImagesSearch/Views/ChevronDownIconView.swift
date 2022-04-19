//
//  ChevronDownIconView.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 15/04/2022.
//

import UIKit

class ChevronDownIconView: UIView {

    private let iconImageView = UIImageView(image: R.image.chevronDown()?.withRenderingMode(.alwaysTemplate))

    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        addElements()
        configure()
    }

    func update(isClosed: Bool) {
        UIView.animate(withDuration: 0.3) { [self] in
            iconImageView.transform = isClosed ? .identity : .init(rotationAngle: .pi)
        }
    }
}

private extension ChevronDownIconView {
    func addElements() {
        snp.makeConstraints {
            $0.width.equalTo(30)
        }
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(15)
            $0.height.equalTo(7)
        }
    }

    func configure() {
        iconImageView.tintColor = R.color.textColor()
    }
}
