//
//  Category.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 11/03/2022.
//

import Foundation

protocol SettingsProtocol {}

enum MediaCategory: String, CaseIterable, SettingsProtocol {
    case all = "All"
    case photo = "Photo"
    case illustration = "Illustration"
    case vector = "Vector"
}

enum MediaQuality: String, CaseIterable, SettingsProtocol {
    case small = "Small"
    case normal = "Normal"
    case large = "Large"
}

enum MediaSource: String, CaseIterable, SettingsProtocol {
    case local = "Local"
    case remote = "Remote"
}
