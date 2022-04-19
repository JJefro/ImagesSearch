//
//  Formatter+Extensions.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 21/03/2022.
//

import Foundation

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter
    }()
}
