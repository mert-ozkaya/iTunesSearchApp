//
//  SoftwareContentUseCase.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 9.09.2023.
//

import Foundation

protocol SoftwareContentUseCase {
    typealias SearchSoftwareContentsCompletion = (Result<SoftwareMediaPresentableModel?, SoftwareContentSearchingError>) -> ()
    typealias AllImageDownloadedCompletion = () -> ()
    func searchSoftwareContents(term: String,
                                completion: @escaping SearchSoftwareContentsCompletion) -> Cancellable?
}

final class SoftwareContentUseCaseImpl: SoftwareContentUseCase {
    private let softwareContentRepository: SoftwareContentRepository
    var imageDownloader = ImageDownloader<String>()

    private(set) var page: Int = 0
    private(set) var lastTerm: String?
    private(set) var isEndOfSearchSoftware: Bool = false
    
    init(softwareContentRepository: SoftwareContentRepository) {
        self.softwareContentRepository = softwareContentRepository
    }
    
    deinit {
        print("deinit \(String(describing: self))")
    }
    
    func searchSoftwareContents(term: String,
                                completion: @escaping SearchSoftwareContentsCompletion) -> Cancellable? {
        if term != lastTerm {
            page = 0
            isEndOfSearchSoftware = false
        } else if term == lastTerm && isEndOfSearchSoftware {
            completion(.failure(.endOfPages))
            return nil
        }
        
        if term == "" {
            completion(.failure(.dataNotfound))
            return nil
        }
        
        if term == lastTerm {
            page += 1
        }
        
        lastTerm = term
        
        return softwareContentRepository.searchSoftwareContents(term: term,
                                                                page: page) { [weak self] (result) in
            switch result {
            case .success(let softwareMediaPage):
                if softwareMediaPage.resultCount == 0 {
                    self?.isEndOfSearchSoftware = true
                    completion(.failure(.resultsEmpty(currentPage: self?.page)))
                    return
                }
                self?.downloadImages(softwareMedia: softwareMediaPage.results, currentPage: self?.page ?? 0, completion: completion)
            case .failure(let error):
                Loger.error("Searching network error: \(error)")
                completion(.failure(.dataNotfound))
            }
        }
    }

    func downloadImages(softwareMedia: [SoftwareMedia], currentPage: Int,
                        completion: @escaping SearchSoftwareContentsCompletion) {
        var allImageUrls = [String]()
        softwareMedia.forEach { item in
            allImageUrls.append(contentsOf: item.screenshotUrls)
        }

        Loger.info("Count of images to dowload: \(allImageUrls.count)")
        imageDownloader.downloadImages(urls: allImageUrls, keys: allImageUrls) { (urlStr, fileSize) in
            if let fileSize {
                completion(.success(.init(url: urlStr, fileSize: fileSize, currentPage: currentPage)))
            } else {
                completion(.failure(.imageNotDownloaded(url: urlStr, currentPage: currentPage)))
            }
        } allImagesDownloaded: {
            Loger.success("All images dowloaded.")
        }
    }
}

enum SoftwareContentSearchingError: Error {
    case dataNotfound
    case endOfPages
    case resultsEmpty(currentPage: Int?)
    case imageNotDownloaded(url: String, currentPage: Int)
}
