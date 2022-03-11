//
//  UIView+Extensions.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 07/03/2022.
//

import UIKit

extension UIImage {
    /// Method for changing the image size
    /// - Parameter size: Set the necessary size
    /// - Returns: Resized image
    func resize(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
