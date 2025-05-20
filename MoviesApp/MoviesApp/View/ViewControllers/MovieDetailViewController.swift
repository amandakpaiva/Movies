//
//  MovieDetailViewController.swift
//  MoviesApp
//
//  Created by Amanda Karolina Santos da Fonseca Paiva

import UIKit

// MARK: - MovieDetailViewController
final class MovieDetailViewController: UIViewController {
    private let movie: Movie
    private var isFavorite = false
    private let favoriteMoviesManager = FavoriteMoviesManager()
    private lazy var viewModel: MoviesViewModel = MoviesViewModel()
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    var coordinator: MoviesCoordinator?
    
    // MARK: - init
    init(movie: Movie, 
         coordinator: MoviesCoordinator?) {
        self.movie = movie
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkIfFavorite()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        setupNavigation()
        setupLayout()
        loadImage()
    }
    
    private func setupNavigation() {
        let favoriteTitle = "favorites_title".localized
        let backTitle = "back_button_title".localized
        navigationItem.leftBarButtonItem = createBackButton(title: backTitle)
        navigationItem.rightBarButtonItem = createHeartButton(
            title: favoriteTitle,
            target: self,
            action: #selector(openFavoritesScreen)
        )
    }
    
    // MARK: - UI
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = movie.title
        label.font = .boldSystemFont(ofSize: 22)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "rating_label".localized + " ⭐️ \(String(format: "%.1f", movie.voteAverage))"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.text = "release_date".localized + " " + movie.releaseDate
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.text = movie.overview
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setTitle("favorite_action".localized, for: .normal)
        button.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            movieImageView,
            titleLabel,
            ratingLabel,
            releaseDateLabel,
            overviewLabel,
            favoriteButton,
        ])
        stack.axis = .vertical
        stack.spacing = 14
        stack.alignment = .center
        return stack
    }()
    
    // MARK: - SetupConstraints
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            movieImageView.heightAnchor.constraint(equalToConstant: 300),
            movieImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func loadImage() {
        viewModel.loadImage(for: movie) { [weak self] image in
            self?.movieImageView.image = image
        }
    }
    
    @objc private func toggleFavorite() {
        isFavorite = viewModel.toggleFavorite(movie: movie)
        updateFavoriteButton()
        
        let title = isFavorite ? "favorite_added".localized : "favorite_removed".localized
        let message = String(format: "%@ \(isFavorite ? "added_to_favorites".localized : "removed_from_favorites".localized)", movie.title)
        AlertManager.showAlert(on: self, title: title, message: message)
    }
    
    private func updateFavoriteButton() {
        let iconName = isFavorite ? "heart.fill" : "heart"
        let heartImage = UIImage(systemName: iconName)?.withTintColor(.red, renderingMode: .alwaysOriginal)
        favoriteButton.setImage(heartImage, for: .normal)
        favoriteButton.setTitle(isFavorite ? "remove_from_favorites".localized : "favorite_action".localized, for: .normal)
    }
    
    private func checkIfFavorite() {
        isFavorite = viewModel.isFavorite(movie: movie)
        updateFavoriteButton()
    }
    
    @objc
    public func openFavoritesScreen() {
        coordinator?.navigateToFavorites()
    }
}
