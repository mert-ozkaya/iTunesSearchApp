//
//  SoftwareMedia.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 9.09.2023.
//

import Foundation

struct SoftwareMedia {
    var screenshotUrls: [String]
}

struct SoftwareMediaPage {
    var resultCount: Int
    var results: [SoftwareMedia]
}
