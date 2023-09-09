//
//  SearchRequestDTO.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 9.09.2023.
//

import Foundation

struct SearchRequestDTO {
    var offset: Int
    var limit: Int = 20
    var term: String
    var media: String
}
