//
//  NetworkService.swift
//  iTunesSearchApp
//
//  Created by Mert Ozkaya on 9.09.2023.
//

import Foundation

protocol NetworkService {
    func request<E: Endpoint, Response: Decodable>(_ request: E,
                                                   response: Response.Type,
                                                   completion: @escaping (Result<Response, Error>) -> ())
}

final class DefaultNetworkService: NetworkService {
    func request<E, Response>(_ endpoint: E,
                              response: Response.Type,
                              completion: @escaping (Result<Response, Error>) -> ()) where E : Endpoint, Response : Decodable {
        guard var urlComponent = URLComponents(string: endpoint.base) else {
            return completion(.failure(NetworkServiceError.invalidBaseUrl))
        }
        
        urlComponent.path = endpoint.path
        
        urlComponent.queryItems = endpoint.parameters.compactMap {
            return .init(name: $0.key, value: $0.value)
        }
        
        guard let url = urlComponent.url else {
            return completion(.failure(NetworkServiceError.invalidBaseUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.allHTTPHeaderFields = endpoint.headers
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(NetworkServiceError.responseNotFound))
            }
            
            guard 200..<300 ~= response.statusCode else{
                return completion(.failure(NetworkServiceError.responseFailed(statusCode: response.statusCode)))
            }
            
            guard let data = data else {
                return completion(.failure(NetworkServiceError.responseDataNotFound))
            }
            
            do {
                let result = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(result))
            } catch let error {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
