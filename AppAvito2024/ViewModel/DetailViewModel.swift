//
//  DetailViewModel.swift
//  AppAvito2024
//
//  Created by Elizaveta Osipova on 9/12/24.
//

import UIKit

class DetailViewModel {

    private let content: MediaContent

    var descriptionText: String? {
        return content.description
    }

    var authorName: String {
        return content.user.name
    }

    init(content: MediaContent) {
        self.content = content
    }

    func loadImage(completion: @escaping (UIImage?) -> Void) {
        UIImageDownloader.downloadImage(from: content.urls.regular, completion: completion)
    }
}
