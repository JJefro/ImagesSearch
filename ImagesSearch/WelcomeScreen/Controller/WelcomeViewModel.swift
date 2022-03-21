//
//  WelcomeViewModel.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 01/03/2022.
//

import Foundation

protocol WelcomeViewModelProtocol {
    var onOpenSearchMediaView: ((String, MediaContents) -> Void)? { get set }
    var categoryList: [MediaCategory] { get }

    func getFirstCategory() -> MediaContents?
}

class WelcomeViewModel: WelcomeViewModelProtocol {
    var onOpenSearchMediaView: ((String, MediaContents) -> Void)?

    private(set) var categoryList: [MediaCategory] = MediaContents.allCases.map { MediaCategory(rawValue: $0.rawValue) }

    func getFirstCategory() -> MediaContents? {
        return MediaContents.allCases.first(where: { $0.rawValue == categoryList.first?.rawValue })
    }
}
