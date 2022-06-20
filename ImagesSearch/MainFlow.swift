//
//  MainFlow.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 03/03/2022.
//

import UIKit

class MainFlow {
    private var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func launch() {
        let welcomeViewModel = WelcomeViewModel()
        let searchMediaViewModel = SearchMediaViewModel(networkManager: NetworkManager.shared)
        
        let welcomeViewController = configureWelcomeViewController(viewModel: welcomeViewModel)
        let searchMediaViewController = configureSearchMediaViewController(viewModel: searchMediaViewModel)

        let navigationController = configureNavigationController(rootViewController: welcomeViewController)
        
        welcomeViewModel.onOpenSearchMediaView = { (text, selectedCategory, categoryList) in
            searchMediaViewModel.mediaData = (text, selectedCategory)
            searchMediaViewModel.setupMediaCategories(list: categoryList)
            navigationController.pushViewController(searchMediaViewController, animated: true)
        }

        searchMediaViewModel.onImageEdit = { image in
            let cropViewController = CropMediaViewController(croppingStyle: .custom, image: image)
            navigationController.pushViewController(cropViewController, animated: true)
        }

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

// MARK: - UIViewControllers Configurtions
private extension MainFlow {
    func configureWelcomeViewController(viewModel: WelcomeViewModelProtocol) -> UIViewController {
        let contentView = WelcomeContentView(mediaCategories: viewModel.categoryList)
        let viewController = WelcomeViewController(contentView: contentView, viewModel: viewModel)
        return viewController
    }
    
    func configureSearchMediaViewController(viewModel: SearchMediaViewModelProtocol) -> UIViewController {
        let contentView = SearchMediaView()
        let viewController = SearchMediaViewController(contentView: contentView, viewModel: viewModel)
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
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }
}
