//
//  AppDelegate.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 28/02/2022.
//

import UIKit
import netfox

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainFlow = MainFlow(window: window)
        mainFlow.launch()
#if DEBUG
        NFX.sharedInstance().start()
#endif
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
#if DEBUG
        NFX.sharedInstance().stop()
#endif
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }
}
