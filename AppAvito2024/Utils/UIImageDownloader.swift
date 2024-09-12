//
//  UIImageDownloader.swift
//  AppAvito2024
//
//  Created by Elizaveta Osipova on 9/12/24.
//


import UIKit

class UIImageDownloader {

    private static var imageCache = NSCache<NSString, UIImage>()

    static func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                imageCache.setObject(image, forKey: urlString as NSString)
                completion(image)
            } else {
                completion(nil)
            }
        }

        task.resume()
    }
}
