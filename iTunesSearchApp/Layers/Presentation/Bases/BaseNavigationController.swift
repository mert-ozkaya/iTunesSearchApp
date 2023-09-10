//
//  BaseNavigationController.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 10.09.2023.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isTranslucent = true
        navigationBar.tintColor = .white
        navigationBar.backgroundColor = .white
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        if #available(iOS 13.0, *) {
            let apperance = UINavigationBarAppearance()
            apperance.configureWithOpaqueBackground()
            apperance.backgroundColor = .white
            apperance.titleTextAttributes = [.foregroundColor: UIColor.black]
            apperance.shadowColor = .lightGray
            navigationBar.standardAppearance = apperance
            navigationBar.scrollEdgeAppearance = apperance
        }
    }
    
}
