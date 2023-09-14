//
//  SoftwareMediaRepositoryImpl.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 9.09.2023.
//

import Foundation

struct SoftwareContentRepositoryImpl: SoftwareContentRepository {
    private var networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func searchSoftwareContents(term: String, page: Int, completion: @escaping (Result<SoftwareMediaPage, Error>) -> ()) -> Cancellable? {
        let requestInput = SearchEndpoint.SearchRequestInput(term: term, media: "software", page: page)
        let repositoryTask = RepositoryTask()
        
        repositoryTask.networkTask = networkService.request(SearchEndpoint.search(input: requestInput),
                                                            response: SearchResponseDTO.self) { (result: Result<SearchResponseDTO, Error>) -> () in
            
            switch result {
            case .success(let dto):
                completion(.success(.init(resultCount: dto.resultCount ?? 0, results: mapToSoftwareMedias(dto.results))))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        return repositoryTask
    }
    
    private func mapToSoftwareMedias(_ searchResults: [SearchResponseDTO.SearchResultItem?]?) -> [SoftwareMedia] {
        guard let searchResults else { return [] }
        
        var items = [SoftwareMedia]()
        
        searchResults.forEach { item in
            if let item, let screenshotUrls = item.screenshotUrls {
                var newScreenShotUrls =  [String]()
                screenshotUrls.forEach { screenshotUrl in
                    if let screenshotUrl {
                        newScreenShotUrls.append(screenshotUrl)
                    }
                }
                items.append(.init(screenshotUrls: newScreenShotUrls))
            }
        }
        
        return items
    }
}
