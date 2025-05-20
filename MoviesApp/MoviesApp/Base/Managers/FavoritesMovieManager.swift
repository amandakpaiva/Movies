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
    
    @discardableResult
    func toggleFavorite(movie: Movie) -> Bool {
        var favorites = loadFavoriteMovies()
        if let index = favorites.firstIndex(where: { $0.id == movie.id }) {
            favorites.remove(at: index)
            saveFavoriteMovies(favorites)
            return false
        } else {
            favorites.append(movie)
            saveFavoriteMovies(favorites)
            return true
        }
    }
    
    func addFavorite(movie: Movie) {
        var favorites = loadFavoriteMovies()
        guard !favorites.contains(where: { $0.id == movie.id }) else { return }
        favorites.append(movie)
        saveFavoriteMovies(favorites)
    }
    
    func removeFavorite(at index: Int) {
        var favorites = loadFavoriteMovies()
        guard favorites.indices.contains(index) else { return }
        favorites.remove(at: index)
        saveFavoriteMovies(favorites)
    }
    
    func removeFavorite(movie: Movie) {
        var favorites = loadFavoriteMovies()
        favorites.removeAll { $0.id == movie.id }
        saveFavoriteMovies(favorites)
    }
}
