//
//  TopNavigationView.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 15/03/2022.
//

import UIKit

class TopNavigationView: UIView {

    // MARK: - Views Configurations
    private let horizontalStack = UIStackView().apply {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 5
    }

    let pixabayButton = UIButton().apply {
        $0.setImage(R.image.pixabayLogo()?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .white
        $0.backgroundColor = R.color.searchButtonBG()
        $0.layer.cornerRadius = 5
    }

    let searchView = SearchView().apply {
        $0.hideCategoryField(isHidden: true)
    }

    let settingsButton = UIButton().apply {
        $0.setImage(R.image.settings()?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = R.color.settingsButtonTintColor()
        $0.backgroundColor = R.color.settingsButtonBG()
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
        $0.layer.borderColor = R.color.searchViewBorderColor()?.cgColor
    }

    private let bottomBorder = UIView().apply {
        $0.backgroundColor = R.color.searchViewBorderColor()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Add Views and Configurations
private extension TopNavigationView {
    func addViews() {
        addNavigationElements()
        addBottomBorder()
    }

    func configure() {
        backgroundColor = R.color.topNavigationViewBG()
    }

    func addNavigationElements() {
        addSubview(horizontalStack)
        horizontalStack.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.edges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        horizontalStack.addArrangedSubviews(pixabayButton, searchView, settingsButton)
        pixabayButton.snp.makeConstraints { $0.size.equalTo(52) }
        settingsButton.snp.makeConstraints { $0.size.equalTo(52) }
    }
    
    func addBottomBorder() {
        addSubview(bottomBorder)
        bottomBorder.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.trailing.leading.bottom.equalToSuperview()
        }
    }
}

// MARK: - Preview Provider
#if DEBUG
#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, *)
struct TopNavigationViewRepresentation: UIViewRepresentable {
    func makeUIView(context: Context) -> TopNavigationView {
        let view = TopNavigationView()
        return view
    }

    func updateUIView(_ uiView: TopNavigationView, context: Context) {}
}

@available(iOS 13, *)
struct TopNavigationViewRepresentablePreview: PreviewProvider {
    static var previews: some View {
        Group {
            TopNavigationViewRepresentation()
        }
        .frame(width: UIScreen.main.bounds.width, height: 81, alignment: .top)
        .preferredColorScheme(.dark)
    }
}
#endif
#endif
