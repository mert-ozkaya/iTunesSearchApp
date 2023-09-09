//
//  NetworkSessionManager.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 9.09.2023.
//

import Foundation

protocol NetworkSessionManager {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

    func request(_ urlRequest: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable?
}


final class DefualtNetworkSessionManager: NetworkSessionManager {
    func request(_ urlRequest: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable? {
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: completion)
        task.resume()
        return task
    }
}
