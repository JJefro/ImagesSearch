//
//  AppDelegate.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 28/02/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let welcomeViewController = configureWelcomeViewController()
        let navController = UINavigationController(rootViewController: welcomeViewController)

        if #available(iOS 13, *) {
            let barAppearance = UINavigationBarAppearance()
            barAppearance.titleTextAttributes = [NSAttributedString.Key.font: R.font.sfProDisplayRegular(size: 15)!]
            navController.navigationBar.standardAppearance = barAppearance
            navController.navigationBar.scrollEdgeAppearance = barAppearance
        } else {
            let barAppearance = UINavigationBar.appearance()
            barAppearance.titleTextAttributes = [NSAttributedString.Key.font: R.font.sfProDisplayRegular(size: 15)!]
        }

        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()

        return true
    }
    private func configureWelcomeViewController() -> UIViewController {
        let viewController = WelcomeViewController()
        return viewController
    }
}
