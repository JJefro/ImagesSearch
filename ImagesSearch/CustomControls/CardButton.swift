//
//  CardButton.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 25/04/2022.
//

import UIKit

class CardButton: UIButton {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: nil)
        super.touchesBegan(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
        super.touchesEnded(touches, with: event)
    }
}
