//
//  SearchMediaPickerView.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 11/03/2022.
//

import UIKit
import SwiftUI

class PickerView: UIPickerView {
    
    var onValueChanged: ((String) -> Void)?
    
    private var categories: [String] = [] {
        didSet {
            reloadAllComponents()
        }
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = R.color.searchViewBG()

        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        delegate = self
        dataSource = self
        isHidden = true
    }

    func setupCategories(data: [String]) {
        categories = data
    }
}

// MARK: - UIPickerView Delegate Methods
extension PickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: categories[row], attributes: [
            NSAttributedString.Key.foregroundColor: R.color.searchMediaPickerText()!
        ])
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        onValueChanged?(categories[row])
    }
}

// MARK: - UIPickerView DataSource Methods
extension PickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
}
