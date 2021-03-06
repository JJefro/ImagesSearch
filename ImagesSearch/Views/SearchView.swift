//
//  SearchView.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 07/03/2022.
//

import UIKit

class SearchView: UIView {

    var onGetSearchFieldValue: ((String?) -> Void)?

    private let backgroundSeparatorView = UIView()
    let searchField = TextFieldView(style: .searchField)
    let chevronDownIconView = ChevronDownIconView()
    
    private let horizontalStack = UIStackView().apply {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 2
    }

    private let separatorView = UIView().apply {
        $0.backgroundColor = .lightGray.withAlphaComponent(0.5)
        $0.layer.cornerRadius = 10
    }

    let categoryLabel = UILabel().apply {
        $0.textColor = R.color.textColor()
        $0.font = R.font.openSansRegular(size: 14)
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        configure()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hideCategoryField(isHidden: Bool) {
        separatorView.isHidden = isHidden
        backgroundSeparatorView.isHidden = isHidden
        categoryLabel.isHidden = isHidden
        chevronDownIconView.isHidden = isHidden
        chevronDownIconView.isHidden = isHidden
    }

    func hideSearchTextField(isHidden: Bool) {
        searchField.isHidden = isHidden
    }
}

// MARK: - SearchView Configurations
private extension SearchView {
    func addViews() {
        addHorizontalStackView()
        horizontalStack.addArrangedSubview(searchField)
        addSeparatorView()
        addCategoryLabel()
        horizontalStack.addArrangedSubview(chevronDownIconView)
    }
    
    func configure() {
        backgroundColor = R.color.searchViewBG()
        clipsToBounds = true
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = R.color.searchViewBorderColor()?.cgColor
        
        searchField.configure(
            textFieldBackgroundColor: backgroundColor,
            viewBackgroundColor: backgroundColor,
            font: R.font.openSansRegular(size: 14)
        )
    }

    func bind() {
        searchField.onTextFieldReturnKeyTap = { [weak self] text in
            self?.onGetSearchFieldValue?(text)
        }
    }

    func addHorizontalStackView() {
        addSubview(horizontalStack)
        horizontalStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func addSeparatorView() {
        horizontalStack.addArrangedSubview(backgroundSeparatorView)
        backgroundSeparatorView.snp.makeConstraints {
            $0.width.equalTo(2)
        }
        backgroundSeparatorView.addSubview(separatorView)
        separatorView.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(2)
            $0.center.equalTo(backgroundSeparatorView.snp.center)
        }
    }
    
    func addCategoryLabel() {
        horizontalStack.addArrangedSubview(categoryLabel)
        categoryLabel.snp.makeConstraints {
            $0.width.equalTo(75)
        }
    }
}

// MARK: - Preview Provider
#if DEBUG
#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, *)
struct SearchViewRepresentation: UIViewRepresentable {
    func makeUIView(context: Context) -> SearchView {
        let view = SearchView()
        return view
    }
    
    func updateUIView(_ uiView: SearchView, context: Context) {}
}

@available(iOS 13, *)
struct SearchViewRepresentablePreview: PreviewProvider {
    static var previews: some View {
        Group {
            SearchViewRepresentation()
        }
        .frame(width: UIScreen.main.bounds.width, height: 100, alignment: .center)
        .preferredColorScheme(.dark)
    }
}
#endif
#endif
