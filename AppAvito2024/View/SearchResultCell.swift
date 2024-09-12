//
//  SearchResultCell.swift
//  AppAvito2024
//
//  Created by Elizaveta Osipova on 9/12/24.
//

import UIKit

class SearchResultCell: UICollectionViewCell {

    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(activityIndicator)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 2

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .systemPurple

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalToConstant: 150),

            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }

    func configure(with content: MediaContent) {
        descriptionLabel.text = content.description ?? ""

        activityIndicator.startAnimating()
        imageView.image = nil

        UIImageDownloader.downloadImage(from: content.urls.small) { [weak self] image in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.imageView.image = image
            }
        }
    }
}
