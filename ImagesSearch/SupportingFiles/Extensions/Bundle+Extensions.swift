//
//  Bundle+Extensions.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 10/05/2022.
//

import Foundation

extension Bundle {
    var appName: String? {
        return object(forInfoDictionaryKey: Contstants.Bundle.displayName) as? String ?? object(forInfoDictionaryKey: Contstants.Bundle.name) as? String
    }
}
