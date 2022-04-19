//
//  Category.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 11/03/2022.
//

import Foundation

struct MediaCategory: RawRepresentable {
    var rawValue: String
}

enum Media: String, CaseIterable {
    case all = "All"
    case photo = "Photo"
    case illustration = "Illustration"
    case vector = "Vector"
}

enum MediaQuality: String, CaseIterable {
    case small = "Small"
    case normal = "Normal"
    case large = "Large"
}
