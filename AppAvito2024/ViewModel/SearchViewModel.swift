//
//  SearchViewModel.swift
//  AppAvito2024
//
//  Created by Elizaveta Osipova on 9/12/24.
//

import Foundation
import Foundation

class SearchViewModel {
    private let maxHistoryCount = 5
    private let searchHistoryKey = "searchHistory"

    var onSearchResultsUpdated: (([MediaContent]) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onErrorOccurred: ((String) -> Void)?

    var searchHistory: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey: searchHistoryKey) ?? []
        }
        set {
            UserDefaults.standard.set(Array(newValue.prefix(maxHistoryCount)), forKey: searchHistoryKey)
        }
    }

    func saveSearchQuery(_ query: String) {
        var history = searchHistory
        if !history.contains(query) {
            history.insert(query, at: 0)
        }
        searchHistory = history
    }

    func search(for query: String) {
        saveSearchQuery(query)
        onLoadingStateChanged?(true)

        UnsplashAPIService().searchMediaContent(query: query) { [weak self] result in
            self?.onLoadingStateChanged?(false)
            switch result {
            case .success(let mediaContents):
                self?.onSearchResultsUpdated?(mediaContents)
            case .failure(let error):
                self?.onErrorOccurred?(error.localizedDescription)
            }
        }
    }
}
