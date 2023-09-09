//
//  SearchEndpoint.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 9.09.2023.
//

import Foundation

enum SearchEndpoint {
    case search(input: SearchRequestInput)
}

extension SearchEndpoint: Endpoint {
    var path: String {
        switch self {
        case .search:
            return "/search"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .search(let requestInput):
            return [
                "offset": String(requestInput.offset),
                "limit": String(requestInput.limit),
                "term": String(requestInput.term),
                "media": String(requestInput.media)
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .search:
            return .GET
        }
    }
    
    var headers: Headers {
        switch self {
        case .search:
            return [ "Content-Type": "application/json" ]
        }
    }
}

extension SearchEndpoint {
    struct SearchRequestInput {
        var offset: Int {
            page * limit
        }
        var limit: Int = 20
        var term: String
        var media: String
        var page: Int
    }
}
