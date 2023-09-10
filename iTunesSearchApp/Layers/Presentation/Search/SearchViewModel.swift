//
//  SearchViewModel.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 9.09.2023.
//

import Foundation

//protocol SearchViewModel {
//    associatedtype State
//    associatedtype Section
//    var stateClosure: ((State) -> ())? { get set }
//    var sections: [Section] { get }
//}

final class SearchViewModel {
    var stateClosure: ((VMState) -> ())?
    var sections: [Section] {
        _sections
    }
    
    private var _sections: [Section] = []
    
    func start() {
        prepareUI()
    }
    
    func prepareUI() {
        var sectionPageContent: [SectionPageContent] = []
        for index in 1...1 {
            let provider1 = OnlyImageCollectionViewProvider()
            provider1.setData(sections: [ .init(headerTitle: CollectionSectionType.between0_100.title, imageURLs: [])])
            sectionPageContent.append(.init(type: .between0_100, provider: provider1))
            
            let provider2 = OnlyImageCollectionViewProvider()
            provider2.setData(sections: [ .init(headerTitle: CollectionSectionType.between100_250.title, imageURLs: [])])
            sectionPageContent.append(.init(type: .between100_250, provider: provider2))
            
            
            let provider3 = OnlyImageCollectionViewProvider()
            provider3.setData(sections: [.init(headerTitle: CollectionSectionType.between250_500.title, imageURLs: [])])
            sectionPageContent.append(.init(type: .between250_500, provider: provider3))
            
            let provider4 = OnlyImageCollectionViewProvider()
            provider4.setData(sections: [ .init(headerTitle: CollectionSectionType.plus500.title, imageURLs: [])])
            sectionPageContent.append(.init(type: .plus500, provider: provider4))
            
            _sections.append(ContentSection(pageHeaderTitle: "Page-\(index)", sectionPageContent: sectionPageContent))
        }
        
        //        _sections.append(NoDataSection())
        
        
        triggerState(.updateUI)
    }
    
    func triggerState(_ state: VMState) {
        DispatchQueue.main.async { [weak self] in
            self?.stateClosure?(.updateUI)
        }
    }
    
    func search(with term: String) {
        print(String(describing: self), "Search: \(term)")
    }
}

protocol Section { }

extension SearchViewModel {
    enum VMState {
        case updateUI
    }
    
    struct NoDataSection: Section {
        var text: String = "Data not found."
    }
    
    struct ContentSection: Section {
        var pageHeaderTitle: String
        //        var dataOfImages: [Data] = []
        var sectionPageContent: [SectionPageContent]
    }
    
    struct SectionPageContent {
        var type: CollectionSectionType
        var provider: OnlyImageCollectionViewProvider
    }
    
    enum CollectionSectionType {
        case between0_100
        case between100_250
        case between250_500
        case plus500
        
        var title: String {
            switch self {
            case .between0_100:
                return "0-100KB"
            case .between100_250:
                return "100-250KB"
            case .between250_500:
                return "250-500KB"
            case .plus500:
                return "500+KB"
            }
        }
    }
    
}

