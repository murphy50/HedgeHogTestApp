//
//  NetworkService.swift
//  HedgehogTestApp
//
//  Created by murphy on 07.02.2023.
//

import Foundation

enum NetworkError: Error {
    case incorrectURL
    case failedRequest
    case decodingError
    case downloadImageError
}

final class NetworkService {
    
    // MARK: - Public properties
    func request(searchTerm: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let parameters = queryParameters(seachTerm: searchTerm)
        guard let url = url(params: parameters) else {
            completion(.failure(NetworkError.incorrectURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        resumeDataTask(from: request, completion: completion)
        
    }
    
    // MARK: - Private properties
    private func url(params: [String: String]) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "serpapi.com"
        components.path = "/search.json"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.url
    }
    
    private func queryParameters(seachTerm: String) -> [String: String] {
        var parameters = [String: String]()
        parameters["q"] = seachTerm
        parameters["tbm"] = "isch"
        parameters["ijn"] = String(0) // defines the page number to get
        parameters["api_key"] = "215aed2545abc8d3a14afb05bc9dfcf18f9413683b52efd789eefab77435ad85"
        return parameters
    }
    
    private func resumeDataTask(from request: URLRequest,
                                completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, error == nil
            else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.failedRequest))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }.resume()
    }
}
