//
//  SoftwareContentUseCase.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 9.09.2023.
//

import Foundation

protocol SoftwareContentUseCase {
    func searchSoftwareContents(term: String, completion: @escaping (Result<SoftwareMediaPage, Error>) -> ()) -> Cancellable?
}

final class SoftwareContentUseCaseImpl: SoftwareContentUseCase {
    private let softwareContentRepository: SoftwareContentRepository
    
    private(set) var page: Int = 0
    private(set) var lastTerm: String?
    private(set) var isEndOfSearchSoftware: Bool = false
    
    init(softwareContentRepository: SoftwareContentRepository) {
        self.softwareContentRepository = softwareContentRepository
    }
    
    func searchSoftwareContents(term: String,
                                completion: @escaping (Result<SoftwareMediaPage, Error>) -> ()) -> Cancellable? {
        if term != lastTerm {
            page = 0
            isEndOfSearchSoftware = false
        } else if term == lastTerm && isEndOfSearchSoftware {
            return nil
        }
        
        lastTerm = term
        
        return softwareContentRepository.searchSoftwareContents(term: term,
                                                                page: page) { [weak self] (result) in
            switch result {
            case .success(let softwareMediaPage):
                if softwareMediaPage.resultCount == 0 {
                    self?.isEndOfSearchSoftware = true
                }
                completion(.success(softwareMediaPage))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
