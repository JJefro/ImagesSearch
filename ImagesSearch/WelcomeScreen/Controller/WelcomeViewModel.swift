//
//  WelcomeViewModel.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 01/03/2022.
//

import Foundation

protocol WelcomeViewModelProtocol {
    var categoryList: [MediaCategory] { get }

    func getFirstCategory() -> MediaCategory?
}

class WelcomeViewModel: WelcomeViewModelProtocol {
    private(set) var categoryList: [MediaCategory] = [MediaCategory(rawValue: "Images"), MediaCategory(rawValue: "Photos")]

    func getFirstCategory() -> MediaCategory? {
        return categoryList.first
    }
}
