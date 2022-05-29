//
//  UITableView+Extensions.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 11/04/2022.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue reusable UITableViewCell")
        }
        return cell
    }

    func updateCellsSize(animated: Bool) {
        func update() {
            beginUpdates()
            endUpdates()
        }
        if animated {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7) {
                update()
            }
        } else {
            UIView.performWithoutAnimation {
                update()
            }
        }
    }
}
