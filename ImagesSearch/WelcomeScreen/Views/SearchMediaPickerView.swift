//
//  SearchMediaPickerView.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 11/03/2022.
//

import UIKit

class SearchMediaPickerView: UIPickerView {
    
    var onValueChanged: ((MediaCategory) -> Void)?
    
    private var mediaCategories: [MediaCategory]?
    
    init(mediaCategories: [MediaCategory]) {
        super.init(frame: .zero)
        self.mediaCategories = mediaCategories
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
}

// MARK: - UIPickerView Delegate Methods
extension SearchMediaPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let mediaCategories = mediaCategories else { return nil }
        return mediaCategories[row].rawValue
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let mediaCategories = mediaCategories else { return }
        onValueChanged?(mediaCategories[row])
    }
}

// MARK: - UIPickerView DataSource Methods
extension SearchMediaPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let mediaCategories = mediaCategories else { return 0 }
        return mediaCategories.count
    }
}
