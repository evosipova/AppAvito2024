//
//  DetailViewModel.swift
//  AppAvito2024
//
//  Created by Elizaveta Osipova on 9/12/24.
//

import Foundation

struct MediaContent: Codable {
    let id: String
    let description: String?
    let urls: MediaContentURLs
    let user: Author
}

struct MediaContentURLs: Codable {
    let small: String
    let regular: String
}

struct Author: Codable {
    let name: String
}
