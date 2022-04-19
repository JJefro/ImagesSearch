//
//  SettingsViewModel.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 18/04/2022.
//

import UIKit

protocol SettingsViewModelProtocol {
    var currentMediaQuality: MediaQuality? { get }
    var currentMediaCategory: MediaCategory? { get }
    func updateWithSettings(value: String)
}

class SettingsViewModel: SettingsViewModelProtocol {

    var currentMediaQuality: MediaQuality?
    var currentMediaCategory: MediaCategory?

    func updateWithSettings(value: String) {
        if let mediaQuality = MediaQuality(rawValue: value), MediaQuality.allCases.contains(mediaQuality) {
            currentMediaQuality = mediaQuality
        } else if let media = Media(rawValue: value), Media.allCases.contains(media) {
            currentMediaCategory = MediaCategory(rawValue: media.rawValue)
        }
    }
}
