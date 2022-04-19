//
//  Int+Extensions.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 21/03/2022.
//

import Foundation

extension Int {
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
}
