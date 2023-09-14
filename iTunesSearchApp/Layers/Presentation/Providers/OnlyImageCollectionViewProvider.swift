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
        let width = (UIScreen.main.bounds.width - 30)/2
        let imageRatio: CGFloat = 696/392
        let height = width*imageRatio
        layout.itemSize = .init(width: width, height: height)
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
    
   var sections: [ViewData] = []
    
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
    
    func addViewData(content: SoftwareMediaPresentableModel) {
        if sections.first(where: { $0.fileSizeRangeType == content.sizeRangeType }) != nil {
            if let index = sections.firstIndex(where: { $0.fileSizeRangeType == content.sizeRangeType }) {
                sections[index].rows.append(content.url)
            }
        } else {
            sections.append(.init(fileSizeRangeType: content.sizeRangeType, rows: [content.url]))            
        }
        
        collectionView.reloadData()
    }
}

extension OnlyImageCollectionViewProvider: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnlyImageViewCollectionCell", for: indexPath) as! OnlyImageViewCollectionCell
            
        cell.setupUI(url: self.sections[indexPath.section].rows[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            // Başlık görünümünü oluşturun ve döndürün
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TitleCollectionHeaderView", for: indexPath) as? TitleCollectionHeaderView {
                headerView.titleLabel.text = sections[indexPath.section].fileSizeRangeType.getTitle()
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
        var fileSizeRangeType: SoftwareMediaDataSizeRangeType
        var rows: [String]
    }
}
