//
//  SettingsTableView.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 11/04/2022.
//

import UIKit

class SettingsTableView: UITableView {

    var onUpdateSettingsValue: ((String) -> Void)?
    var settingsObjects: [SettingsModel] = [] {
        didSet {
            reloadData()
        }
    }

    private var selectedCellIndexPath: IndexPath?
    private var isCellInOpenState: Bool = false
    private let selectedCellHeight: CGFloat = 120
    private let unselectedCellHeight: CGFloat = 45

    init() {
        super.init(frame: .zero, style: .grouped)
        configure()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SettingsTableView {

    func configure() {
        register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        separatorStyle = .none
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        insetsContentViewsToSafeArea = false
    }

    func bind() {
        delegate = self
        dataSource = self
    }
}

extension SettingsTableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isCellInOpenState.toggle()
        selectedCellIndexPath = indexPath
        updateCellsSize(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isCellInOpenState, selectedCellIndexPath == indexPath {
            return selectedCellHeight
        }
        tableView.deselectRow(at: indexPath, animated: true)
        return unselectedCellHeight
    }
}

extension SettingsTableView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsObjects.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setupCell(data: settingsObjects[indexPath.section])
        cell.onUpdateSettingsValue = onUpdateSettingsValue
        return cell
    }
}
