//
//  SearchViewController.swift
//  AppAvito2024
//
//  Created by Elizaveta Osipova on 9/12/24.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    private let viewModel = SearchViewModel()
    private var mediaContents: [MediaContent] = []
    private var filteredSearchHistory: [String] = []
    private var searchHistory: [String] = []

    private let searchBar = UISearchBar()
    private var collectionView: UICollectionView!
    private var tableView: UITableView!
    private let padding: CGFloat = 16

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupBindings()
    }

    private func setupUI() {
        searchBar.delegate = self
        searchBar.placeholder = "Найти"
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = .clear

        let stackView = UIStackView(arrangedSubviews: [searchBar])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.width - (padding * 3)) / 2, height: 200)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: "SearchResultCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false



        view.addSubview(collectionView)

        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "historyCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),

            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        loadSearchHistory()
    }

    private func setupBindings() {
        viewModel.onSearchResultsUpdated = { [weak self] results in
            self?.mediaContents = results
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    private func loadSearchHistory() {
        if let savedHistory = UserDefaults.standard.array(forKey: "searchHistory") as? [String] {
            searchHistory = savedHistory
        }
    }

    private func saveToSearchHistory(_ query: String) {
        if searchHistory.contains(query) {
            return
        }
        if searchHistory.count >= 5 {
            searchHistory.removeFirst()
        }
        searchHistory.append(query)
        UserDefaults.standard.set(searchHistory, forKey: "searchHistory")
    }

    // UISearchBarDelegate

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        viewModel.search(for: query)
        saveToSearchHistory(query)
        searchBar.resignFirstResponder()
        tableView.isHidden = true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredSearchHistory = []
            tableView.isHidden = true
        } else {
            filteredSearchHistory = searchHistory.filter { $0.lowercased().contains(searchText.lowercased()) }
            tableView.isHidden = false
            tableView.reloadData()
        }
    }

    // UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaContents.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        let content = mediaContents[indexPath.item]
        cell.configure(with: content)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedContent = mediaContents[indexPath.item]
        let detailVC = DetailViewController(content: selectedContent)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // UITableViewDataSource (для отображения истории поиска)

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSearchHistory.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        cell.textLabel?.text = filteredSearchHistory[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedQuery = filteredSearchHistory[indexPath.row]
        searchBar.text = selectedQuery
        searchBarSearchButtonClicked(searchBar)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}
