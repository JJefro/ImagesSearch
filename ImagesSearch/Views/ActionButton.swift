//
//  ActionButton.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 20/04/2022.
//

import UIKit

class ActionButton: CardButton {

    enum ButtonType {
        case search, download, share
    }

    private let currentButtonType: ButtonType
    private let imageAttachment = NSTextAttachment().apply {
        $0.bounds = CGRect(x: 0, y: -2, width: 22, height: 22)
    }

    init(type: ButtonType) {
        self.currentButtonType = type
        super.init(frame: .zero)
        setTitle()
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension ActionButton {
    func setTitle() {
        let attrString = NSAttributedString(attachment: imageAttachment)
        let mutableAttributedString = NSMutableAttributedString(attributedString: attrString)

        switch currentButtonType {
        case .search:
            imageAttachment.image = R.image.magnifyingglass()
            imageAttachment.setImageHeight(height: 22)
            mutableAttributedString.append(NSMutableAttributedString(
                string: "  " + R.string.localizable.actionButton_search_title(),
                attributes: [NSAttributedString.Key.font: R.font.openSansSemiBold(size: 22)!]))

        case .download:
            imageAttachment.image = R.image.download()
            imageAttachment.setImageHeight(height: 22)
            mutableAttributedString.append(NSMutableAttributedString(
                string: "  " + R.string.localizable.actionButton_dowload_title(),
                attributes: [NSAttributedString.Key.font: R.font.openSansSemiBold(size: 22)!]))

        case .share:
            imageAttachment.image = R.image.share()
            imageAttachment.setImageHeight(height: 14)
            mutableAttributedString.append(NSMutableAttributedString(
                string: "  " + R.string.localizable.actionButton_share_title(),
                attributes: [NSAttributedString.Key.font: R.font.openSansSemiBold(size: 14)!]))
        }
        setAttributedTitle(mutableAttributedString, for: .normal)
        setTitleColor(currentButtonType == .share ? R.color.textColor() : .white, for: .normal)
    }
}

// MARK: - Configurations
private extension ActionButton {
    func configure() {
        switch currentButtonType {
        case .share:
            layer.cornerRadius = 3
            layer.borderWidth = 1
            layer.borderColor = R.color.shareButtonTintColor()?.cgColor
            backgroundColor = .clear
        default:
            layer.cornerRadius = 5
            backgroundColor = R.color.searchButtonBG()
        }
    }
}
