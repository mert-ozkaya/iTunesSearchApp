//
//  SearchVC.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 8.09.2023.
//

import UIKit

class SearchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let aaa = DefaultNetworkService()
        aaa.request(SearchEndpoint.search(input: .init(offset: 20,
                                                                                               term: "ekk",
                                                                                               media: "software")),
                                        response: SearchResponseDTO.self) { result in
            switch result {
            case .success(let response):
                print("resss: \(response)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

}
