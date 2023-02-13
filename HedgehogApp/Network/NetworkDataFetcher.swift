//
//  ImageFetcher.swift
//  HedgehogTestApp
//
//  Created by murphy on 10.02.2023.
//

import Foundation
import UIKit
var failsImages: Int = 0
var successImages: Int = 0
final class NetworkDataFetcher {
    static let shared = NetworkDataFetcher()
    
    private let networkService = NetworkService()
    func fetchImages(searchTerm: String, completion: @escaping (Result<Images, Error>) -> Void) {
        networkService.request(searchTerm: searchTerm) { [self] result in
            switch result {
            case .success(let data):
                do {
                    let searchData = try data.decodeJSON(to: ResponseData.self)
                    let imagesData = searchData.imagesData
                    let lock = NSLock()
                    let group = DispatchGroup()
                    var images: Images = []
                    let batch = 20
                    for i in stride(from: 0, to: imagesData.count, by: batch) {
                        var j = i
                        while (j < i+batch && j < imagesData.count) {
                            let imageData = imagesData[j]
                            group.enter()
                            download(from: imageData.thumbnail) { result in
                                switch result {
                                case .success(let image):
                                    lock.with { images.append(Image(imageData: imageData, thumbnail: image)) }
                                    group.leave()
                                case .failure(let error):
                                    print(error)
                                    group.leave()
                                }
                            }
                            j += 1
                        }
                        group.notify(queue: DispatchQueue.main) {
                            completion(.success(images))
                        }
                    }
                } catch {
                    completion(.failure(error))
                    return
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func download(from link: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: link) else {
            completion(.failure(NetworkError.incorrectURL))
            return
        }
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 2
        sessionConfig.timeoutIntervalForResource = 4
        let session = URLSession(configuration: sessionConfig)
        session.dataTask(with: url) {  data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                completion(.failure(NetworkError.downloadImageError))
                return
            }
            completion(.success(image))
        }.resume()
    }
}

extension Data {
    func decodeJSON<T: Decodable>(to type: T.Type) throws -> T {
        do {
            let object = try JSONDecoder().decode(type.self, from: self)
            return object
        } catch {
            throw NetworkError.decodingError
        }
    }
}
