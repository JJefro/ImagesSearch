//
//  ReusableViewProtocol.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 17/03/2022.
//

import Foundation

protocol ReusableViewProtocol {
    static var identifier: String { get }
}

extension ReusableViewProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
