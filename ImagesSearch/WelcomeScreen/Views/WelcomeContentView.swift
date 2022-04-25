//
//  WelcomeContentView.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 01/03/2022.
//

import UIKit
import SnapKit

protocol WelcomeContentViewProtocol: UIView {
    var onSearchButtonTap: ((String?, MediaCategory?) -> Void)? { get set }
    
    func selectCategory(category: MediaCategory?)
}

class WelcomeContentView: UIView, WelcomeContentViewProtocol {
    var onSearchButtonTap: ((String?, MediaCategory?) -> Void)?

    private let backgroundImageView = UIImageView().apply {
        $0.image = R.image.welcomeBGImage()
        $0.alpha = 0.4
        $0.contentMode = .scaleToFill
    }

    private let titleLabel = UILabel().apply {
        $0.font = R.font.openSansExtraBold(size: 26)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.text = R.string.localizable.welcomeContentView_titleLabel()
    }

    private let verticalStack = UIStackView().apply {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 29
    }

    private let bottomDescriptionLabel = UILabel().apply {
        $0.font = R.font.openSansRegular(size: 12)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.text = R.string.localizable.welcomeContentView_bottomDescriptionLabel()
    }

    private var mediaPickerView = PickerView().apply {
        $0.backgroundColor = R.color.searchViewBG()
    }

    private let searchView = SearchView()
    private let searchButton = ActionButton(type: .search)
    private var selectedCategory: MediaCategory? {
        didSet {
            searchView.categoryLabel.text = selectedCategory?.rawValue
        }
    }
    
    init(mediaCategories: [MediaCategory]) {
        super.init(frame: .zero)
        mediaPickerView.setupCategories(
            data: mediaCategories.map { $0.rawValue })
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let touch = touches.first
        guard let location = touch?.location(in: self) else { return }
        if !isCategoryFieldContains(location: location) {
            hideMediaPickerView(isHidden: true)
        }
    }
    
    func selectCategory(category: MediaCategory?) {
        selectedCategory = category
    }
}

// MARK: - Private Methods
private extension WelcomeContentView {
    @objc func categoryFieldTapped(_ sender: UITapGestureRecognizer) {
        endEditing(true)
        hideMediaPickerView(isHidden: false)
    }
    
    @objc func searchButtonTapped(_ sender: UIButton) {
        onSearchButtonTap?(searchView.searchField.txtField.text, selectedCategory)
    }
    
    func addTapGesture(view: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.categoryFieldTapped(_:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        if notification.name == UIResponder.keyboardWillShowNotification {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
                self?.hideMediaPickerView(isHidden: true)
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

    func hideMediaPickerView(isHidden: Bool) {
        mediaPickerView.isHidden = isHidden
        searchView.chevronDownIconView.update(isClosed: isHidden)
    }

    func isCategoryFieldContains(location: CGPoint) -> Bool {
        if searchView.categoryLabel.frame.contains(location), searchView.chevronDownIconView.frame.contains(location) {
            return true
        }
        return false
    }
}

// MARK: - Bind Elements
private extension WelcomeContentView {
    func bind() {
        addTapGesture(view: searchView.categoryLabel)
        addTapGesture(view: searchView.chevronDownIconView)
        searchButton.addTarget(self, action: #selector(searchButtonTapped(_:)), for: .touchUpInside)
        addObserverToNotificationCenter()
        bindMediaPickerView()
        bindSearchView()
    }

    func bindMediaPickerView() {
        mediaPickerView.onValueChanged = { [weak self] value in
            self?.selectedCategory = MediaCategory(rawValue: value)
        }
    }

    func bindSearchView() {
        searchView.onGetSearchFieldValue = { [weak self] text in
            self?.onSearchButtonTap?(text, self?.selectedCategory)
        }
    }
}

// MARK: - WelcomeContentView Configurations
private extension WelcomeContentView {
    func addViews() {
        addBackgroundImageView()
        addSearchElements()
        addTitleLabel()
        addBottomDescriptionLabel()
        addPickerView()
    }
    
    func addBackgroundImageView() {
        insertSubview(backgroundImageView, at: 0)
        backgroundImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func addSearchElements() {
        addSubview(verticalStack)
        verticalStack.snp.makeConstraints {
            $0.top.equalTo(snp.centerY).offset(-50)
            $0.trailing.leading.equalToSuperview().inset(20)
        }
        verticalStack.addArrangedSubviews(searchView, searchButton)
        searchView.snp.makeConstraints { $0.height.equalTo(52) }
        searchButton.snp.makeConstraints { $0.height.equalTo(52) }
    }
    
    func addTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(verticalStack.snp.top).offset(-63)
            $0.trailing.leading.equalToSuperview().inset(20)
        }
    }
    
    func addBottomDescriptionLabel() {
        addSubview(bottomDescriptionLabel)
        bottomDescriptionLabel.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.centerX.equalToSuperview()
        }
    }
    
    func addPickerView() {
        addSubview(mediaPickerView)
        mediaPickerView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom)
            $0.trailing.leading.equalTo(verticalStack)
            $0.height.equalTo(85)
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
        let view = WelcomeContentView(mediaCategories: [MediaCategory(rawValue: "Images")])
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
