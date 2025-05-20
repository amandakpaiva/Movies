//
//  MockFavoriteMoviesManager.swift
//  MoviesAppTests
//
//  Created by Amanda Karolina Santos da Fonseca Paiva on 07/02/25.
//

import UIKit
@testable import MoviesApp
class MockFavoriteMoviesManager: FavoriteMoviesManager {
    private var favoriteMovies: [Movie] = []
    
    override func loadFavoriteMovies() -> [Movie] {
        return favoriteMovies
    }
    
    override func saveFavoriteMovies(_ movies: [Movie]) {
        favoriteMovies = movies
    }
}
