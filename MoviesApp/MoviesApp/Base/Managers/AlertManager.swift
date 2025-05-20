//
//  AlertManager.swift
//  MoviesApp
//
//  Created by Amanda Karolina Santos da Fonseca Paiva

import UIKit

final class AlertManager {
    static func showAlert(on viewController: UIViewController, title: String, message: String, actions: [UIAlertAction]? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        guard let actions = actions else {
            let defaultAction = UIAlertAction(title: "OK".localized, style: .default)
            alertController.addAction(defaultAction)
            viewController.present(alertController, animated: true)
            return
        }
        
        actions.forEach { alertController.addAction($0) }
        viewController.present(alertController, animated: true)
    }

    static func handleFavoriteAction(for movie: Movie, in viewController: UIViewController, completionHandler: @escaping (Bool) -> Void) {
        let isFavorite = FavoriteMoviesManager().isMovieFavorite(movie)
        
        guard !isFavorite else {
            let title = "Atenção".localized
            let message = String(format: "%@ \(movie.title) " + "já está na sua lista de favoritos.".localized, movie.title)
            showAlert(on: viewController, title: title, message: message)
            completionHandler(false)
            return
        }
        
        var favoriteMovies = FavoriteMoviesManager().loadFavoriteMovies()
        favoriteMovies.append(movie)
        FavoriteMoviesManager().saveFavoriteMovies(favoriteMovies)
        
        let title = "Favorito".localized
        let message = String(format: "%@ " + "foi adicionado aos favoritos!".localized, movie.title)
        showAlert(on: viewController, title: title, message: message)
        completionHandler(true)
    }
}
