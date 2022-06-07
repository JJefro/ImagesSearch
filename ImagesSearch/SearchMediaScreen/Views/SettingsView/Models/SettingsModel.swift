//
//  SettingsModel.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 11/04/2022.
//

import Foundation

struct SettingsModel {
    var title: String
    var selectedItem: String
    var pickerValues: [String]
}

enum MediaCategory: String, CaseIterable {
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

enum MediaSource: String, CaseIterable {
    case local = "Local"
    case remote = "Remote"
}
