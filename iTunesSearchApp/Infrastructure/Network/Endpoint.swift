//
//  Endpoint.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 9.09.2023.
//

import Foundation

typealias Parameters = [String: String]
typealias Headers = [String: String]

protocol Endpoint {
    associatedtype Response = Codable
    var base: String { get }
    var path: String { get }
    var parameters: Parameters { get }
    var method: HTTPMethod { get }
    var headers: Headers { get }
}

extension Endpoint {
    var base: String {
        return "https://itunes.apple.com"
    }
}

extension Endpoint where Response: Decodable {
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}


enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
}
