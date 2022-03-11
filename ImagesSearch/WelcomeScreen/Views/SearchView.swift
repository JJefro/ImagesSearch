//
//  SearchView.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 07/03/2022.
//

import UIKit

class SearchView: UIView {
    private let searchField = TextFieldView(style: .searchField)
    private let horizontalStack = UIStackView()
    
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
        
        searchField.configure(
            textFieldBackgroundColor: backgroundColor,
            viewBackgroundColor: backgroundColor,
            font: R.font.openSansRegular(size: 14)
        )
    }
    
    func addHorizontalStackView() {
        horizontalStack.axis = .horizontal
        horizontalStack.distribution = .fill
        horizontalStack.spacing = 5
        
        addSubview(horizontalStack)
        horizontalStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func addSeparatorView() {
        let separatorView = UIView()
        let backgroundSeparatorView = UIView()
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
        let bgChevronDownView = UIView()
        let image = R.image.chevronDown()?.withRenderingMode(.alwaysTemplate)
        chevronDownImageView.image = image
        chevronDownImageView.tintColor = R.color.textColor()
        
        horizontalStack.addArrangedSubview(bgChevronDownView)
        bgChevronDownView.snp.makeConstraints {
            $0.width.equalTo(30)
        }
        bgChevronDownView.addSubview(chevronDownImageView)
        chevronDownImageView.snp.makeConstraints {
            $0.width.equalTo(15)
            $0.height.equalTo(7)
            $0.centerY.equalTo(bgChevronDownView.snp.centerY)
            $0.trailing.equalTo(bgChevronDownView.snp.trailing).inset(15)
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
