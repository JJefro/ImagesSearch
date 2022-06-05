//
//  WelcomeViewModel.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 01/03/2022.
//

import Foundation

protocol WelcomeViewModelProtocol {
    var onOpenSearchMediaView: ((String, MediaCategory, [MediaCategory]) -> Void)? { get set }
    var categoryList: [MediaCategory] { get }

    func getFirstCategory() -> MediaCategory?
}

class WelcomeViewModel: WelcomeViewModelProtocol {
    var onOpenSearchMediaView: ((String, MediaCategory, [MediaCategory]) -> Void)?

    private(set) var categoryList: [MediaCategory] = MediaCategory.allCases

    func getFirstCategory() -> MediaCategory? {
        return categoryList.first
    }
}
