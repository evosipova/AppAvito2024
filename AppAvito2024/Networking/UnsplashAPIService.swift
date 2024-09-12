//
//  UnsplashAPIService.swift
//  AppAvito2024
//
//  Created by Elizaveta Osipova on 9/12/24.
//

import Foundation

struct UnsplashResponse: Decodable {
    let results: [MediaContent]
}

class UnsplashAPIService {

    private let baseURL = "https://api.unsplash.com/"
    private let apiKey = "uDRKlVSx0m2sFNYMyBPw_DEDfSfV9pEzsjWMMlaX32U"


    func searchMediaContent(query: String, completion: @escaping (Result<[MediaContent], Error>) -> Void) {
        let urlString = "\(baseURL)search/photos?query=\(query)&client_id=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 500, userInfo: nil)))
                return
            }

            do {
                let result = try JSONDecoder().decode(UnsplashResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
