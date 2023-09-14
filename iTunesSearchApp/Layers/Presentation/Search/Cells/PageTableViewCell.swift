//
//  PageTableViewCell.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 10.09.2023.
//

import UIKit

class PageTableViewCell: UITableViewCell {
    
    var collectionViewProvider: OnlyImageCollectionViewProvider?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI(collectionViewProvider: OnlyImageCollectionViewProvider) {
        self.collectionViewProvider = collectionViewProvider
        self.collectionViewProvider!.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionViewProvider)
        
        NSLayoutConstraint.activate([
            self.collectionViewProvider!.topAnchor.constraint(equalTo: topAnchor),
            self.collectionViewProvider!.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.collectionViewProvider!.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.collectionViewProvider!.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
