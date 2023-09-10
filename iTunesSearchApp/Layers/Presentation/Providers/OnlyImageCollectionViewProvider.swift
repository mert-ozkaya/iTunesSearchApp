//
//  OnlyImageCollectionViewProvider.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 10.09.2023.
//

import UIKit

final class OnlyImageCollectionViewProvider: UIView {
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: (UIScreen.main.bounds.width - 30)/2, height: 174)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.headerReferenceSize = .init(width: UIScreen.main.bounds.width, height: 30)
        collectionView.contentInset = .init(top: 0, left: 10, bottom: 20, right: 10)
        collectionView.collectionViewLayout = layout
        collectionView.isScrollEnabled = false
        collectionView.register(OnlyImageViewCollectionCell.self,
                                forCellWithReuseIdentifier: "OnlyImageViewCollectionCell")
        collectionView.register(TitleCollectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "TitleCollectionHeaderView")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var sections: [ViewData] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .yellow
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        collectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(sections: [ViewData]) {
        self.sections = sections
        self.collectionView.reloadData()
    }
}

extension OnlyImageCollectionViewProvider: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnlyImageViewCollectionCell", for: indexPath) as! OnlyImageViewCollectionCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            // Başlık görünümünü oluşturun ve döndürün
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TitleCollectionHeaderView", for: indexPath) as? TitleCollectionHeaderView {
                headerView.titleLabel.text = sections[indexPath.section].headerTitle
                return headerView
            }
        }
        return UICollectionReusableView()
    }
}

extension OnlyImageCollectionViewProvider: UICollectionViewDelegate {
}

extension OnlyImageCollectionViewProvider {
    struct ViewData {
        var headerTitle: String
        var imageURLs: [String]
    }
}
