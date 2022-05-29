//
//  Constants.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 03/05/2022.
//

import Foundation

struct Contstants {
    
    static var pixabayLicenseURLComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "pixabay.com"
        components.path = "/service/license"
        return components
    }

    struct Bundle {
        static let displayName = "CFBundleDisplayName"
        static let name = "CFBundleName"
    }
}
