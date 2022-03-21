//
//  NetworkManager.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 17/03/2022.
//

import UIKit

protocol NetworkManagerProtocol {
    func searchMedia(by text: String, content: MediaContents, completion: @escaping (Result<ContentEntityProtocol, Error>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    private var pixabayURLComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "pixabay.com"
        components.path = "/api"
        
        let apiKeyQueryItem = URLQueryItem(name: "key", value: "26184943-7a248bddb4548b6a38c2cc80c")
        components.queryItems = [apiKeyQueryItem]
        return components
    }
    
    func searchMedia(by text: String, content: MediaContents, completion: @escaping (Result<ContentEntityProtocol, Error>) -> Void) {
        var components = pixabayURLComponents
        let textQueryItem = URLQueryItem(name: "q", value: text)

        switch content {
        case .images:
            let categoryQueryItem = URLQueryItem(name: "image_type", value: content.rawValue)
            components.queryItems?.append(contentsOf: [textQueryItem, categoryQueryItem])
        case .videos:
            components.path = "/api/videos"
            components.queryItems?.append(textQueryItem)
        case .music:
            break
        }

        performRequest(url: components.url, completion: completion)
    }
    
    private func performRequest(url: URL?, completion: @escaping (Result<ContentEntityProtocol, Error>) -> Void) {
        guard let url = url else {
            completion(.failure(NetworkError.unknownURL))
            return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                if let error = error { completion(.failure(error)) }
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(NetworkError.unknownServerResponse))
                    return
                }
                guard let data = data else {
                    completion(.failure(NetworkError.noDataReceived))
                    return
                }
                guard response.statusCode / 100 == 2 else {
                    completion(.failure(NetworkError.unknownStatusCode))
                    return
                }
                completion(self.parseJSON(data: data))
            }
        }
        task.resume()
    }
    
    private func parseJSON(data: Data) -> Result<ContentEntityProtocol, Error> {
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(PixabayModel.self, from: data)
            return .success(PixabayImagesEntity(data: decoderData))
        } catch {
            return .failure(error)
        }
    }
}
