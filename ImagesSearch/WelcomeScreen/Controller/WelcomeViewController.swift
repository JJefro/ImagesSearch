//
//  ViewController.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 28/02/2022.
//

import UIKit

class WelcomeViewController: UIViewController {

    private let contentView: WelcomeContentViewProtocol
    private var viewModel: WelcomeViewModelProtocol
    
    init(contentView: WelcomeContentViewProtocol, viewModel: WelcomeViewModelProtocol) {
        self.contentView = contentView
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
        contentView.onSearchButtonTap = { (text, category) in
            print(text!)
            print(category!.rawValue)
        }
    }
}
