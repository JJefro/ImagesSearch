//
//  WelcomeContentView.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 06/03/2022.
//

import UIKit
import SnapKit

class WelcomeContentView: UIView {

    private let titleLabel = UILabel()
    private let verticalStack = UIStackView()
    let textFieldView = TextFieldView()
    let searchButton = UIButton()
    private let bottomDescriptionLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        addViews()
        backgroundColor = .black
    }
}

// MARK: - WelcomeContentView Configurations
private extension WelcomeContentView {
    func addViews() {
        addBackgroundImageView()
        addVerticalStack()
        addSearchButton()
        addTitleLabel()
        addBottomDescriptionLabel()
    }

    func configure() {
        backgroundColor = .black
        // TODO: -  Create search textField view
        // Temporarily
        textFieldView.fieldSettings = .searchField
    }

    func addBackgroundImageView() {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = R.image.welcomeBackgroundImage()
        backgroundImageView.alpha = 0.4
        backgroundImageView.contentMode = .scaleToFill

        insertSubview(backgroundImageView, at: 0)
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func addVerticalStack() {
        verticalStack.axis = .vertical
        verticalStack.distribution = .equalSpacing
        verticalStack.spacing = 20

        addSubview(verticalStack)
        verticalStack.snp.makeConstraints {
            $0.top.equalTo(snp.centerY).offset(-50)
            $0.trailing.leading.equalToSuperview().inset(20)
        }
        verticalStack.addArrangedSubview(textFieldView)
    }

    func addSearchButton() {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = R.image.magnifyingglass()
        imageAttachment.bounds = CGRect(x: 0, y: -2, width: 22, height: 22)

        let imageString = NSAttributedString(attachment: imageAttachment)
        let buttonTitle = NSMutableAttributedString(attributedString: imageString)
        buttonTitle.append(NSMutableAttributedString(
            string: "  " + R.string.localizable.welcomeContentView_searchButton_title(),
            attributes: [NSAttributedString.Key.font: R.font.openSansSemiBold(size: 22)!]))

        searchButton.setAttributedTitle(buttonTitle, for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.layer.cornerRadius = 5
        searchButton.backgroundColor = R.color.searchButtonBackgroundColor()

        verticalStack.addArrangedSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
            $0.height.equalTo(textFieldView.txtField.snp.height)
        }
    }

    func addTitleLabel() {
        titleLabel.font = R.font.openSansExtraBold(size: 26)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = R.string.localizable.welcomeContentView_titleLabel()

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(verticalStack.snp.top).offset(-63)
            $0.trailing.leading.equalToSuperview().inset(20)
        }
    }

    func addBottomDescriptionLabel() {
        bottomDescriptionLabel.font = R.font.openSansRegular(size: 12)
        bottomDescriptionLabel.textColor = .white
        bottomDescriptionLabel.textAlignment = .center
        bottomDescriptionLabel.numberOfLines = 0
        bottomDescriptionLabel.text = R.string.localizable.welcomeContentView_bottomDescriptionLabel()

        addSubview(bottomDescriptionLabel)
        bottomDescriptionLabel.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.centerX.equalToSuperview()
        }
    }
}

#if DEBUG
#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, *)
struct WelcomeContentViewRepresentation: UIViewRepresentable {
    func makeUIView(context: Context) -> WelcomeContentView {
        let view = WelcomeContentView()
        return view
    }

    func updateUIView(_ uiView: WelcomeContentView, context: Context) {}
}

@available(iOS 13, *)
struct WelcomeContentViewRepresentablePreview: PreviewProvider {
    static var previews: some View {
        Group {
            WelcomeContentViewRepresentation()
        }
        .preferredColorScheme(.dark)
    }
}
#endif
#endif
