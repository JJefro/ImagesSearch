//
//  NSTextAttachment+Extensions.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 21/04/2022.
//

import UIKit

extension NSTextAttachment {
    func setImageHeight(height: CGFloat) {
        guard let image = image else { return }
        let ratio = image.size.width / image.size.height
        bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: ratio * height, height: height)
    }
}
