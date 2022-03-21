//
//  SearchView.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 07/03/2022.
//

import UIKit

class SearchView: UIView {
    
    private let horizontalStack = UIStackView()
    private let separatorView = UIView()
    private let backgroundSeparatorView = UIView()
    private let backgroundChevronDownView = UIView()
    
    let searchField = TextFieldView(style: .searchField)
    let categoryLabel = UILabel()
    let chevronDownImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hideCategoryField(isHidden: Bool) {
        separatorView.isHidden = isHidden
        backgroundSeparatorView.isHidden = isHidden
        categoryLabel.isHidden = isHidden
        chevronDownImageView.isHidden = isHidden
        backgroundChevronDownView.isHidden = isHidden
    }
}

// MARK: - SearchView Configurations
private extension SearchView {
    func addViews() {
        addHorizontalStackView()
        horizontalStack.addArrangedSubview(searchField)
        addSeparatorView()
        addCategoryLabel()
        addChevronDownImageView()
    }
    
    func configure() {
        backgroundColor = R.color.searchViewBackgroundColor()
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
    
    func addHorizontalStackView() {
        horizontalStack.axis = .horizontal
        horizontalStack.distribution = .fill
        horizontalStack.spacing = 2
        
        addSubview(horizontalStack)
        horizontalStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func addSeparatorView() {
        separatorView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        separatorView.layer.cornerRadius = 10
        
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
        categoryLabel.textColor = R.color.textColor()
        categoryLabel.font = R.font.openSansRegular(size: 14)
        categoryLabel.textAlignment = .center
        
        horizontalStack.addArrangedSubview(categoryLabel)
        categoryLabel.snp.makeConstraints {
            $0.width.equalTo(60)
        }
    }
    
    func addChevronDownImageView() {
        let image = R.image.chevronDown()?.withRenderingMode(.alwaysTemplate)
        chevronDownImageView.image = image
        chevronDownImageView.tintColor = R.color.textColor()
        
        horizontalStack.addArrangedSubview(backgroundChevronDownView)
        backgroundChevronDownView.snp.makeConstraints {
            $0.width.equalTo(30)
        }
        backgroundChevronDownView.addSubview(chevronDownImageView)
        chevronDownImageView.snp.makeConstraints {
            $0.width.equalTo(15)
            $0.height.equalTo(7)
            $0.centerY.equalTo(backgroundChevronDownView.snp.centerY)
            $0.trailing.equalTo(backgroundChevronDownView.snp.trailing).inset(15)
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
