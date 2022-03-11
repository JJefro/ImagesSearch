//
//  WelcomeContentView.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 01/03/2022.
//

import UIKit
import SnapKit

protocol WelcomeContentViewProtocol: UIView {
    var onSearchButtonTap: (() -> Void)? { get set }
}

class WelcomeContentView: UIView, WelcomeContentViewProtocol {
    var onSearchButtonTap: (() -> Void)?
    
    private let titleLabel = UILabel()
    private let verticalStack = UIStackView()
    private let searchView = SearchView()
    private let searchButton = UIButton()
    private let bottomDescriptionLabel = UILabel()
    let pickerView = UIPickerView()
    
    private var selectedCategory: String? {
        didSet {
            searchView.categoryLabel.text = selectedCategory
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        addViews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first
        guard let location = touch?.location(in: self) else { return }
        if !searchView.categoryLabel.frame.contains(location), !searchView.chevronDownImageView.frame.contains(location) {
            pickerView.isHidden = true
        }
    }
    
    func selectCategory(category: String?) {
        selectedCategory = category
    }
    
    @objc func categoryFieldTapped(_ sender: UITapGestureRecognizer) {
        pickerView.isHidden.toggle()
    }
    
    @objc func searchButtonTapped(_ sender: UIButton) {
        onSearchButtonTap?()
    }
    
    private func addTapGesture(view: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.categoryFieldTapped(_:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        if notification.name == UIResponder.keyboardWillShowNotification {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
                self?.pickerView.isHidden = true
            }
        }
    }
    
    func addObserverToNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustForKeyboard(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
}

// MARK: - WelcomeContentView Configurations
private extension WelcomeContentView {
    func addViews() {
        addBackgroundImageView()
        addVerticalStack()
        addSearchView()
        addSearchButton()
        addTitleLabel()
        addBottomDescriptionLabel()
        addPickerView()
    }
    
    func bind() {
        addTapGesture(view: searchView.categoryLabel)
        addTapGesture(view: searchView.chevronDownImageView)
        searchButton.addTarget(self, action: #selector(searchButtonTapped(_:)), for: .touchUpInside)
        addObserverToNotificationCenter()
        pickerView.isHidden = true
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
        verticalStack.spacing = 29
        
        addSubview(verticalStack)
        verticalStack.snp.makeConstraints {
            $0.top.equalTo(snp.centerY).offset(-50)
            $0.trailing.leading.equalToSuperview().inset(20)
        }
    }
    
    func addSearchView() {
        verticalStack.addArrangedSubview(searchView)
        searchView.snp.makeConstraints {
            $0.height.equalTo(52)
        }
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
            $0.height.equalTo(searchView.snp.height)
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
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.centerX.equalToSuperview()
        }
    }
    
    func addPickerView() {
        pickerView.backgroundColor = searchView.backgroundColor
        
        addSubview(pickerView)
        pickerView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom).offset(5)
            $0.trailing.leading.equalTo(verticalStack)
            $0.height.equalTo(100)
        }
    }
}

// MARK: - Preview Provider
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
