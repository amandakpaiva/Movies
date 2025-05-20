//
//  MoviesCoordinator.swift
//  MoviesApp
//
//  Created by Amanda Karolina Santos da Fonseca Paiva

import UIKit

class MoviesCoordinator {
    private var navigationController: UINavigationController
    private var moviesViewController: MoviesViewController?
    private var movieDetailViewController: MovieDetailViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.moviesViewController = MoviesViewController(viewModel: MoviesViewModel(), coordinator: self)
    }
    
    func start() {
        if let moviesVC = moviesViewController {
            navigationController.pushViewController(moviesVC, animated: true)
        }
    }
    
    func showMovieDetail(movie: Movie) {
        let detailVC = MovieDetailViewController(movie: movie, coordinator: self)
        movieDetailViewController = detailVC
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    func navigateToFavorites() {
        let favoritesVC = FavoritesHostingController(coordinator: self)
        navigationController.pushViewController(favoritesVC, animated: true)
    }
}
