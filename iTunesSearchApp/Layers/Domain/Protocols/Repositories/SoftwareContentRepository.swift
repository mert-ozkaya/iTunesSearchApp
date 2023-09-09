//
//  SoftwareContentRepository.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 9.09.2023.
//

import Foundation

protocol SoftwareContentRepository {
    @discardableResult
    func searchSoftwareContents(term: String, page: Int, completion: @escaping (Result<SoftwareMediaPage, Error>) -> ()) -> Cancellable?
}
