//
//  SoftwareMediaPresentableModel.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 14.09.2023.
//

import Foundation

struct SoftwareMediaPresentableModel {
    private(set) var sizeRangeType: SoftwareMediaDataSizeRangeType
    var url: String
    var currentPage: Int
    
    init(url: String, fileSize: Double, currentPage: Int) {
        self.url = url
        self.currentPage = currentPage
        
        if fileSize < 100 {
            sizeRangeType = .between0_100
        } else if fileSize >= 100 && fileSize < 250 {
            sizeRangeType = .between100_250
        } else if fileSize >= 250 && fileSize < 500 {
            sizeRangeType = .between250_500
        } else {
            sizeRangeType = .plus500
        }
    }
}

enum SoftwareMediaDataSizeRangeType: Int {
    case between0_100 = 0
    case between100_250
    case between250_500
    case plus500
}
