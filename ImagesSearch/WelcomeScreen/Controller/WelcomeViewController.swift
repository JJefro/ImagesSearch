//
//  ViewController.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 28/02/2022.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        navigationItem.title = "Welcome"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}

private extension WelcomeViewController {
    func configure() {
        setBackgroundImage()
    }

    func setBackgroundImage() {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = R.image.welcomeBackgroundImage()
        backgroundImageView.alpha = 0.5
        backgroundImageView.contentMode = .scaleToFill

        view.insertSubview(backgroundImageView, at: 0)
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
