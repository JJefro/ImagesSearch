//
//  StackView+Extensions.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 18/04/2022.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ subviews: UIView...) {
        subviews.forEach(addArrangedSubview(_:))
    }
}
