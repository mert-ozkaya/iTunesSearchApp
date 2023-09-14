//
//  Environment.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 14.09.2023.
//

import Foundation

final class Environment {
    
    enum KeyType: String {
        case apiBaseUrl = "API_BASE_URL"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }
        
        return dict
    }()
    
    static let apiBaseURL: String = {
        guard let apiBaseUrl = Environment.infoDictionary[KeyType.apiBaseUrl.rawValue] as? String else {
            fatalError("API base url not set in plist")
        }
        
        return "https://" + apiBaseUrl + "/resources/documentation/itunes-store-web-service-search-api"
    }()
}
