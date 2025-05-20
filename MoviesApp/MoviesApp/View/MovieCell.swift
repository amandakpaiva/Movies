//
//  MovieCell.swift
//  MoviesApp
//
//  Created by Amanda Karolina Santos da Fonseca Paiva
//
//

import UIKit

// MARK: - MovieCell
class MovieCell: UITableViewCell {
    
    static let identifier = "MovieCell"
    private var currentIndexPath: IndexPath?
    private var currentImageURL: String?
    
    //MARK: UI
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            movieImageView.widthAnchor.constraint(equalToConstant: 120),
            
            
            titleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            ratingLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            ratingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(movieImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingLabel)
        setupConstraints()
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: Setup
    func configure(with movie: Movie, viewModel: MoviesViewModel, indexPath: IndexPath) {
        titleLabel.text = movie.title
        ratingLabel.text = viewModel.formattedRating(for: movie)
        let urlString = "https://image.tmdb.org/t/p/w200\(movie.posterPath)"
        currentImageURL = urlString
        movieImageView.image = nil

        viewModel.loadImage(for: movie) { [weak self] image in
            guard let self = self, self.currentImageURL == urlString else { return }
            DispatchQueue.main.async {
                self.movieImageView.image = image
            }
        }
    }
}
