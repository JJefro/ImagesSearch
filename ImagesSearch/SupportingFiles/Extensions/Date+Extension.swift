//
//  Date+Extension.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 16/05/2022.
//

import Foundation

extension Date {
    var formattedWithMediumStyle: String { Formatter.mediumDateStyle.string(from: self) }
}
