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
    private var softwareContentUseCase: SoftwareContentUseCase
    private var taskCancellable: Cancellable?

    init(softwareContentUseCase: SoftwareContentUseCase) {
        self.softwareContentUseCase = softwareContentUseCase
    }
    
    
    func start() {
        prepareUI()
    }
    
    func prepareUI() {
//        var sectionPageContent: [SectionPageContent] = []
//        for index in 1...1 {
//            let provider1 = OnlyImageCollectionViewProvider()
//            provider1.setData(sections: [ .init(headerTitle: CollectionSectionType.between0_100.title, rows: [])])
//            sectionPageContent.append(.init(type: .between0_100, provider: provider1))
//
//            let provider2 = OnlyImageCollectionViewProvider()
//            provider2.setData(sections: [ .init(headerTitle: CollectionSectionType.between100_250.title, rows: [])])
//            sectionPageContent.append(.init(type: .between100_250, provider: provider2))
//
//
//            let provider3 = OnlyImageCollectionViewProvider()
//            provider3.setData(sections: [.init(headerTitle: CollectionSectionType.between250_500.title, rows: [])])
//            sectionPageContent.append(.init(type: .between250_500, provider: provider3))
//
//            let provider4 = OnlyImageCollectionViewProvider()
//            provider4.setData(sections: [ .init(headerTitle: CollectionSectionType.plus500.title, rows: [])])
//            sectionPageContent.append(.init(type: .plus500, provider: provider4))
//
//            _sections.append(ContentSection(pageHeaderTitle: "Page-\(index)", page: index, sectionPageContent: sectionPageContent))
//        }
        
        //        _sections.append(NoDataSection())
        
        
        triggerState(.updateUI)
    }
    
    func triggerState(_ state: VMState) {
        DispatchQueue.main.async { [weak self] in
            self?.stateClosure?(state)
        }
    }
    
    func search(with term: String) {
        Loger.info("\(String(describing: self)) Search: \(term)")
        _sections.removeAll()
        taskCancellable?.cancel()
        taskCancellable = softwareContentUseCase.searchSoftwareContents(term: term, completion: { [weak self] (result) in
            switch result {
            case .success(let content):
                DispatchQueue.main.async {
                    self?.searchSuccessResult(content: content)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.searchFailureResult(error: error)
                }
            }
        })
    }
    
    private func searchSuccessResult(content: (SoftwareMediaPresentableModel?)) {
        if let content {
            addNewSoftwareContent(content: content)
        }
    }
    
    private func searchFailureResult(error: SoftwareContentSearchingError) {
        switch error {
        case .dataNotfound:
            Loger.error("\(String(describing: self)) >> searchFailureResult >> dataNotfound")
            if _sections.isEmpty {
                _sections.append(NoDataSection())
                triggerState(.updateUI)
            }
        case .endOfPages:
            Loger.error("\(String(describing: self)) >> searchFailureResult >> endOfPages")
        case .resultsEmpty(let currentPage):
            Loger.error("\(String(describing: self)) >> searchFailureResult >> resultsEmpty >> page: \(String(describing: currentPage))")
            if currentPage == 0 {
                _sections.removeAll()
                _sections.append(NoDataSection())
                triggerState(.updateUI)
            }
        case .imageNotDownloaded(let url, let currentPage):
            Loger.error("\(String(describing: self)) >> imageNotDownloaded >> imageURL: \(url) ___ page: \(currentPage)")
        }
    }
    
    func addNewSoftwareContent(content: SoftwareMediaPresentableModel?) {
        guard let content = content else { return }
        
        if let tableViewSection = getTableViewSection(page: content.currentPage) {
            tableViewSection.collectionViewProvider.addViewData(content: content, delegate: self)
        } else {
            let collectionViewProvider = OnlyImageCollectionViewProvider()
            collectionViewProvider.setData(sections: [.init(fileSizeRangeType: content.sizeRangeType, rows: [content.url])], delegate: self)
            _sections.append(TableViewSection(page: content.currentPage, pageHeaderTitle: "Page-\(content.currentPage + 1)", collectionViewProvider: collectionViewProvider))
        }
        
        triggerState(.updateUI)
    }
    
    func getTableViewSection(page: Int) -> TableViewSection? {
        return (_sections as? [TableViewSection])?.first(where: { $0.page == page})
    }
    
}

extension SearchViewModel: OnlyImageCVProviderDelegate {
    func didSelect(url: String) {
        triggerState(.openImagePoster(url: url))
    }
}

protocol Section { }

extension SearchViewModel {
    enum VMState {
        case updateUI
        case openImagePoster(url: String)
    }
    
    struct NoDataSection: Section {
        var text: String = "Data not found."
    }
    
    struct TableViewSection: Section {
        var page: Int
        var pageHeaderTitle: String
        var collectionViewProvider: OnlyImageCollectionViewProvider
    }
    
    struct ShowMoreFooter: Section {
    }
}

extension SoftwareMediaDataSizeRangeType {
    func getTitle() -> String{
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
