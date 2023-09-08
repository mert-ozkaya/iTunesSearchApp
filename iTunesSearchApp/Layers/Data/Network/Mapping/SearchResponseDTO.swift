//
//  SearchResponseDTO.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 9.09.2023.
//

import Foundation

struct SearchResponseDTO: Decodable {
    var resultCount: Int?
    var results: [SearchResultItem?]?
    
    struct SearchResultItem: Decodable {
        var screenshotUrls: [String?]?
    }
}
