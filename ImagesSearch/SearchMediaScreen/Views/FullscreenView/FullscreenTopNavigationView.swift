//
//  FullscreenTopNavigationView.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 06/05/2022.
//

import UIKit

class FullscreenTopNavigationView: UIView {

    var onReturnButtonTap: (() -> Void)?
    var onEditButtonTap: (() -> Void)?

    private let blurView = BlurView()
    private let horizontalContentStack = UIStackView().apply {
        $0.axis = .horizontal
        $0.distribution = .fill
    }

    private let returnButton = UIButton().apply {
        let image = R.image.chevronLeft()?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = R.color.textColor()
    }

    private let titleLabel = UILabel().apply {
        $0.font = R.font.openSansSemiBold(size: 14)
        $0.textColor = R.color.textColor()
    }

    private let editButton = UIButton().apply {
        $0.setTitle(
            R.string.localizable.fullscreenNavigationView_editButton_title(),
            for: .normal
        )
        $0.setTitleColor(R.color.textColor(), for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addElements()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension FullscreenTopNavigationView {
    @objc func returnButtonTapped(_ sender: UIButton) {
        onReturnButtonTap?()
    }

    @objc func editButtonTapped(_ sender: UIButton) {
        onEditButtonTap?()
    }
}

private extension FullscreenTopNavigationView {
    func addElements() {
        addBlurView()
        addSubview(horizontalContentStack)
        horizontalContentStack.snp.makeConstraints { $0.edges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        horizontalContentStack.addArrangedSubviews(returnButton, titleLabel, editButton)
        returnButton.snp.makeConstraints { $0.size.equalTo(35) }
        editButton.snp.makeConstraints { $0.size.equalTo(35) }
    }

    func addBlurView() {
        addSubview(blurView)
        blurView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    func bind() {
        returnButton.addTarget(self, action: #selector(returnButtonTapped(_:)), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
    }
}
