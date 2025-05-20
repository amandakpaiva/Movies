//
//  MoviesViewModel.swift
//  MoviesApp
//
//  Created by Amanda Karolina Santos da Fonseca Paiva
//

import UIKit
import Network

final class MoviesViewModel {
    // MARK: - Dependencies
    private var movieService: MovieServiceProtocol
    private var favoriteMoviesManager: FavoriteMoviesManager
    
    // MARK: - Data
    private(set) var movies: [Movie] = []
    private(set) var filteredMovies: [Movie] = []
    private var searchDebounceWorkItem: DispatchWorkItem?
    
    // MARK: - Callbacks
    var favoriteMovies: [Movie] = []
    var onMoviesUpdated: (() -> Void)?
    var onFavoritesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Init
    init(movieService: MovieServiceProtocol = MovieService(),
         favoriteMoviesManager: FavoriteMoviesManager = FavoriteMoviesManager()) {
        self.movieService = movieService
        self.favoriteMoviesManager = favoriteMoviesManager
        self.movieService.delegate = self
        self.filteredMovies = loadCachedMovies()
        self.movies = self.filteredMovies
    }
    
    // MARK: - Networking
    func fetchMovies() {
        movieService.fetchMovies()
    }
    
    // MARK: - Cache helpers
    private func cacheMovies(_ movies: [Movie]) {
        if let data = try? JSONEncoder().encode(MoviesResponse(page: 1, results: movies)) {
            UserDefaults.standard.set(data, forKey: "cachedPopularMovies")
        }
    }

    
    private func loadCachedMovies() -> [Movie] {
        guard let data = UserDefaults.standard.data(forKey: "cachedPopularMovies"),
              let response = try? JSONDecoder().decode(MoviesResponse.self, from: data) else {
            return []
        }
        return response.results
    }
    
    // MARK: - Search
    func searchMovies(with query: String) {
        searchDebounceWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            
            guard !query.isEmpty else {
                self.filteredMovies = !self.movies.isEmpty ? self.movies : self.loadCachedMovies()
                self.onMoviesUpdated?()
                return
            }
            
            
            if let service = self.movieService as? MovieService, service.isNetworkAvailable {
                service.searchMovies(query: query)
            } else {
                let source = !self.movies.isEmpty ? self.movies : self.loadCachedMovies()
                self.filteredMovies = source.filter { $0.title.range(of: query, options: .caseInsensitive) != nil }
                self.onMoviesUpdated?()
            }
        }
        
        searchDebounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: workItem)
    }
    
    // MARK: - Images
    func loadImage(for movie: Movie?,
                   from urlString: String? = nil,
                   completion: @escaping (UIImage?) -> Void) {
        guard let url = movie?.posterPath ?? urlString else {
            completion(nil)
            return
        }
        let fullURL = movie != nil ? "https://image.tmdb.org/t/p/w500\(url)" : url
        movieService.loadImage(from: fullURL, completion: completion)
    }
    
    // MARK: - Favorites
    func loadFavoriteMovies() {
        favoriteMovies = favoriteMoviesManager.loadFavoriteMovies()
        onFavoritesUpdated?()
    }
    
    func addFavorite(movie: Movie) {
        favoriteMovies.append(movie)
        favoriteMoviesManager.saveFavoriteMovies(favoriteMovies)
        onFavoritesUpdated?()
    }
    
    func removeFavorite(at index: Int) {
        favoriteMovies.remove(at: index)
        favoriteMoviesManager.saveFavoriteMovies(favoriteMovies)
        onFavoritesUpdated?()
    }
    
    func toggleFavorite(movie: Movie) -> Bool {
        var favorites = favoriteMoviesManager.loadFavoriteMovies()
        guard let index = favorites.firstIndex(where: { $0.id == movie.id }) else {
            favorites.append(movie)
            favoriteMoviesManager.saveFavoriteMovies(favorites)
            return true
        }

        favorites.remove(at: index)
        favoriteMoviesManager.saveFavoriteMovies(favorites)
        return false
    }

    
    func formattedRating(for movie: Movie) -> String {
        "⭐️ \(String(format: "%.1f", movie.voteAverage))"
    }
    
    func isFavorite(movie: Movie) -> Bool {
        favoriteMoviesManager.loadFavoriteMovies().contains { $0.id == movie.id }
    }
}

// MARK: - MovieServiceDelegate
extension MoviesViewModel: MovieServiceDelegate {
    func didFetchMovies(_ movies: [Movie]) {
        cacheMovies(movies)
        self.movies = movies
        self.filteredMovies = movies
        onMoviesUpdated?()
    }
    
    func didFailWithError(_ error: MovieServiceError) {
        onError?(error.localizedDescription)
    }
}
