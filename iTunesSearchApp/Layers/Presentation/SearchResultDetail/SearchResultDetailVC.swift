//
//  SearchResultDetailVC.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 15.09.2023.
//

import UIKit
import Kingfisher

class SearchResultDetailVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage(with: imageUrl)
    }
    
    private func setImage(with url: String?) {
        guard let url else { return }
        imageView.kf.setImage(with: URL(string: url))
    }

    @IBAction func closeScreen(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
