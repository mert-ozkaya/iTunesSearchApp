//
//  AppDelegate.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 8.09.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let searchVC = SearchVC()
        searchVC.binVM(viewModel: .init())
        let navigationController = BaseNavigationController(rootViewController: searchVC)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

