//
//  ViewController.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 28/02/2022.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {

    private var contentView = WelcomeContentView()
    private var viewModel: WelcomeViewModelProtocol

    init(viewModel: WelcomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addContentView()
        configure()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    @objc func searchButtonTapped(_ sender: UIButton) {
    }
}

private extension WelcomeViewController {
    func addContentView() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configure() {
        view.backgroundColor = .black
    }

    func bind() {
        addTargetsToWelcomeContentViewElements()
    }

    func addTargetsToWelcomeContentViewElements() {
        contentView.searchButton.addTarget(self, action: #selector(searchButtonTapped(_:)), for: .touchUpInside)
    }
}
