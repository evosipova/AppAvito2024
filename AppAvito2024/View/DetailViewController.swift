//
//  DetailViewController.swift
//  AppAvito2024
//
//  Created by Elizaveta Osipova on 9/12/24.
//

import UIKit

class DetailViewController: UIViewController {

    private let viewModel: DetailViewModel

    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let authorLabel = UILabel()
    private let shareButton = UIButton(type: .system)
    private let saveButton = UIButton(type: .system)

    init(content: MediaContent) {
        self.viewModel = DetailViewModel(content: content)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureView()
    }

    private func setupUI() {
        view.backgroundColor = .white

        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center

        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        authorLabel.textColor = .gray
        authorLabel.textAlignment = .center

        configureButton(shareButton, title: "Share", icon: "square.and.arrow.up")
        configureButton(saveButton, title: "Save", icon: "square.and.arrow.down")

        view.addSubview(imageView)
        view.addSubview(descriptionLabel)
        view.addSubview(authorLabel)
        view.addSubview(shareButton)
        view.addSubview(saveButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 250),
            imageView.heightAnchor.constraint(equalToConstant: 250),

            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            authorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            shareButton.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 20),
            shareButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            shareButton.widthAnchor.constraint(equalToConstant: 50),
            shareButton.heightAnchor.constraint(equalToConstant: 50),

            saveButton.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            saveButton.widthAnchor.constraint(equalToConstant: 50),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func configureButton(_ button: UIButton, title: String, icon: String) {
        button.setImage(UIImage(systemName: icon), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureView() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .systemPurple
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])

        activityIndicator.startAnimating()

        viewModel.loadImage { [weak self] image in
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                self?.imageView.image = image
            }
        }

        descriptionLabel.text = viewModel.descriptionText ?? ""
        authorLabel.text = "Author: \(viewModel.authorName)"
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func shareImage() {
        guard let image = imageView.image else { return }
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }

    @objc private func saveImage() {
        guard let image = imageView.image else {
            let alert = UIAlertController(title: "Error", message: "Unable to save image. No image found.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
            return
        }

        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alert = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
