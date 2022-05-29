//
//  Formatter+Extensions.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 21/03/2022.
//

import Foundation

extension Formatter {
    static let withSeparator = NumberFormatter().apply {
        $0.numberStyle = .decimal
        $0.groupingSeparator = " "
    }

    static let mediumDateStyle = DateFormatter().apply {
        $0.dateStyle = .medium
        $0.timeStyle = .none
    }
}
