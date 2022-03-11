//
//  ViewController.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 28/02/2022.
//

import UIKit

class WelcomeViewController: UIViewController {

    private let contentView = WelcomeContentView()
    private var viewModel: WelcomeViewModelProtocol
    
    init(viewModel: WelcomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        contentView.selectCategory(category: viewModel.getFirstCategory())
    }
}

private extension WelcomeViewController {
    func bind() {
        contentView.pickerView.delegate = self
        contentView.pickerView.dataSource = self
    }
}

// MARK: - UIPickerView Delegate Methods
extension WelcomeViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.categoryList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        contentView.selectCategory(category: viewModel.categoryList[row])
    }
}

// MARK: - UIPickerView DataSource Methods
extension WelcomeViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.categoryList.count
    }
}
