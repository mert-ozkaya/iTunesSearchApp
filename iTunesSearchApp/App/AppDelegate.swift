//
//  AppDelegate.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 8.09.2023.
//

import UIKit
import Kingfisher

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {        
        ImageCache.default.diskStorage.config.sizeLimit = 1000 * 1024 * 1024
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let searchVC = SearchVC()
        let networkService = DefaultNetworkService()
        let softwareContentRepo = SoftwareContentRepositoryImpl(networkService: networkService)
        let softwareContentUseCase = SoftwareContentUseCaseImpl(softwareContentRepository: softwareContentRepo)
        searchVC.binVM(viewModel: .init(softwareContentUseCase: softwareContentUseCase))
        let navigationController = BaseNavigationController(rootViewController: searchVC)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

