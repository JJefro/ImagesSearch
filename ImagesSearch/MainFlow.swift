//
//  MainFlow.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 03/03/2022.
//

import UIKit

class MainFlow {
    private var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func launch() {
        let welcomeViewController = configureWelcomeViewController()
        let navigationController = configureNavigationController(rootViewController: welcomeViewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

// MARK: - UIViewControllers Configurtions
private extension MainFlow {
    func configureWelcomeViewController() -> UIViewController {
        let viewModel = WelcomeViewModel()
        let viewController = WelcomeViewController(viewModel: viewModel)
        viewController.setInterfaceOrientationMask(orientation: .portrait)
        viewController.addKeyboardHideOnTappedAroundRecognizer()
        return viewController
    }
}

// MARK: - NavigationController Configurations
private extension MainFlow {
    func configureNavigationController(rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        if #available(iOS 13, *) {
            let barAppearance = UINavigationBarAppearance()
            barAppearance.titleTextAttributes = [NSAttributedString.Key.font: R.font.openSansRegular(size: 15)!]
            navigationController.navigationBar.standardAppearance = barAppearance
            navigationController.navigationBar.scrollEdgeAppearance = barAppearance
        } else {
            let barAppearance = UINavigationBar.appearance()
            barAppearance.titleTextAttributes = [NSAttributedString.Key.font: R.font.openSansRegular(size: 15)!]
        }
        return navigationController
    }
}
