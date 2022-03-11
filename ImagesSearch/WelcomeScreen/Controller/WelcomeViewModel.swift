//
//  WelcomeViewModel.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 01/03/2022.
//

import Foundation

protocol WelcomeViewModelProtocol {
    var categoryList: [String] { get }

    func getFirstCategory() -> String?
}

class WelcomeViewModel: WelcomeViewModelProtocol {
    private(set) var categoryList: [String] = ["Images", "Photos", "sdasdas", "dasdasd", "dasdasda"]

    func getFirstCategory() -> String? {
        return categoryList.first
    }
}
