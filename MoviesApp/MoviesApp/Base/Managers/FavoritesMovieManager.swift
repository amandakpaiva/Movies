//
//  FavoritesMovieManager.swift
//  MoviesApp
//
//  Created by Amanda Karolina Santos da Fonseca Paiva

import Foundation
import UIKit

class FavoriteMoviesManager {
    private let userDefaults = UserDefaults.standard
    private let favoriteMoviesKey = "favoriteMovies"
    
    func saveFavoriteMovies(_ movies: [Movie]) {
        if let encodedData = try? JSONEncoder().encode(movies) {
            userDefaults.set(encodedData, forKey: favoriteMoviesKey)
        }
    }
    
    func loadFavoriteMovies() -> [Movie] {
        if let data = userDefaults.data(forKey: favoriteMoviesKey),
           let decodedMovies = try? JSONDecoder().decode([Movie].self, from: data) {
            return decodedMovies
        }
        return []
    }
    
    func isMovieFavorite(_ movie: Movie) -> Bool {
        let favoriteMovies = loadFavoriteMovies()
        return favoriteMovies.contains { $0.id == movie.id }
    }
}
