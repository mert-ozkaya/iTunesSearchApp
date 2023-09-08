//
//  NetworkServiceError.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 9.09.2023.
//

import Foundation

enum NetworkServiceError: Error {
    case invalidBaseUrl
    case responseNotFound
    case responseFailed(statusCode: Int)
    case responseDataNotFound
}
