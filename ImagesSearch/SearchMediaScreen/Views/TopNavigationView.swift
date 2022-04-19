//
//  TopNavigationView.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 15/03/2022.
//

import UIKit

class TopNavigationView: UIView {

    private let horizontalStack = UIStackView()
    private let bottomBorder = UIView()
    let pixabayButton = UIButton()
    let searchView = SearchView()
    let settingsButton = UIButton().apply {
        let settingsButtonImage = R.image.settings()?.withRenderingMode(.alwaysTemplate)
        $0.setImage(settingsButtonImage, for: .normal)
        $0.tintColor = R.color.settingsButtonTintColor()
        $0.backgroundColor = R.color.settingsButtonBG()
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
        $0.layer.borderColor = R.color.searchViewBorderColor()?.cgColor
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TopNavigationView {
    func addViews() {
        addHorizontalStackView()
        addPixabayButton()
        addSearchView()
        addSettingsButton()
        addBottomBorder()
    }

    func addHorizontalStackView() {
        horizontalStack.axis = .horizontal
        horizontalStack.distribution = .equalSpacing
        horizontalStack.spacing = 5
        
        addSubview(horizontalStack)
        horizontalStack.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.edges.equalToSuperview().inset(16)
        }
    }

    func addPixabayButton() {
        let pixabayButtonImage = R.image.pixabayLogo()?.withRenderingMode(.alwaysTemplate)
        pixabayButton.setImage(pixabayButtonImage, for: .normal)
        pixabayButton.tintColor = .white
        pixabayButton.backgroundColor = R.color.searchButtonBG()
        pixabayButton.layer.cornerRadius = 5
        
        horizontalStack.addArrangedSubview(pixabayButton)
        pixabayButton.snp.makeConstraints {
            $0.width.equalTo(52)
        }
    }

    func addSearchView() {
        searchView.hideCategoryField(isHidden: true)
        horizontalStack.addArrangedSubview(searchView)
    }

    func addSettingsButton() {
        horizontalStack.addArrangedSubview(settingsButton)
        settingsButton.snp.makeConstraints {
            $0.width.equalTo(52)
        }
    }
    
    func addBottomBorder() {
        bottomBorder.backgroundColor = R.color.searchViewBorderColor()
        
        addSubview(bottomBorder)
        bottomBorder.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.trailing.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
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
