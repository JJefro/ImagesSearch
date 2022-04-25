//
//  SettingsTableViewCell.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 11/04/2022.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    var onUpdateSettingsValue: ((String) -> Void)?

    private let topHorizontalStack = UIStackView().apply {
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    private let labelsVerticalStack = UIStackView().apply {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }

    private let titleLabel = UILabel().apply {
        $0.font = R.font.openSansRegular(size: 13)
        $0.textColor = R.color.grayTextColor()
        $0.textAlignment = .left
    }

    private let selectedItemLabel = UILabel().apply {
        $0.font = R.font.openSansRegular(size: 13)
        $0.textColor = R.color.textColor()
        $0.textAlignment = .left
    }

    private let chevronDownIconView = ChevronDownIconView()
    private let settingsPickerView = PickerView().apply {
        $0.isHidden = false
    }

    private var pickerValues: [String] = [] {
        didSet {
            settingsPickerView.setupCategories(data: pickerValues)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        configure()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(data: SettingsModel) {
        titleLabel.text = data.title
        selectedItemLabel.text = data.selectedItem
        pickerValues = data.pickerValues
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        chevronDownIconView.update(isClosed: !selected)
        if selected, let selectedItemIndex = pickerValues.firstIndex(where: { $0 == selectedItemLabel.text }) {
            settingsPickerView.selectRow(selectedItemIndex, inComponent: 0, animated: true)
        }
    }
}

private extension SettingsTableViewCell {

    func addViews() {
        addTopElements()
        addSettingsPickerView()
    }

    func configure() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        clipsToBounds = true
        layer.borderColor = R.color.searchViewBorderColor()?.cgColor
        contentView.backgroundColor = R.color.searchViewBG()
    }

    func bind() {
        settingsPickerView.onValueChanged = { [weak self] value in
            guard let self = self else { return }
            self.selectedItemLabel.text = value
            self.onUpdateSettingsValue?(value)
        }
    }

    func addTopElements() {
        contentView.addSubview(topHorizontalStack)
        topHorizontalStack.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(5)
            $0.height.equalTo(30)
        }
        labelsVerticalStack.addArrangedSubviews(titleLabel, selectedItemLabel)
        topHorizontalStack.addArrangedSubviews(labelsVerticalStack, chevronDownIconView)
    }

    func addSettingsPickerView() {
        contentView.addSubview(settingsPickerView)
        settingsPickerView.snp.makeConstraints {
            $0.top.equalTo(topHorizontalStack.snp.bottom).inset(-10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }
    }
}
