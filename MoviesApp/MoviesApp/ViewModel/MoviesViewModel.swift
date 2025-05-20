//
//  MoviesViewModel.swift
//  MoviesApp
//
//  Created by Amanda Karolina Santos da Fonseca Paiva
//

import Foundation
import UIKit
import Network

final class MoviesViewModel: ObservableObject {
    private var movieService: MovieServiceProtocol
    private var favoriteMoviesManager: FavoriteMoviesManager

    @Published private(set) var movies: [Movie] = []
    @Published private(set) var filteredMovies: [Movie] = []
    @Published private(set) var favoriteMovies: [Movie] = []

    var onMoviesUpdated: (() -> Void)?
    var onFavoritesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    private var searchDebounceWorkItem: DispatchWorkItem?

    init(movieService: MovieServiceProtocol = MovieService(),
         favoriteMoviesManager: FavoriteMoviesManager = FavoriteMoviesManager()) {
        self.movieService = movieService
        self.favoriteMoviesManager = favoriteMoviesManager
        self.movieService.delegate = self
        let cached = loadCachedMovies()
        movies = cached
        filteredMovies = cached
        loadFavoriteMovies()
    }

    func fetchMovies() {
        movieService.fetchMovies()
    }

    private func cacheMovies(_ movies: [Movie]) {
        guard !movies.isEmpty,
              let data = try? JSONEncoder().encode(MoviesResponse(page: 1, results: movies))
        else { return }
        UserDefaults.standard.set(data, forKey: "cachedPopularMovies")
    }

    private func loadCachedMovies() -> [Movie] {
        guard let data = UserDefaults.standard.data(forKey: "cachedPopularMovies"),
              let resp = try? JSONDecoder().decode(MoviesResponse.self, from: data)
        else { return [] }
        return resp.results
    }

    func searchMovies(with query: String) {
        searchDebounceWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            guard !query.isEmpty else {
                filteredMovies = movies.isEmpty ? loadCachedMovies() : movies
                onMoviesUpdated?()
                return
            }
            guard let svc = movieService as? MovieService, svc.isNetworkAvailable else {
                let source = movies.isEmpty ? loadCachedMovies() : movies
                filteredMovies = source.filter {
                    $0.title.range(of: query, options: .caseInsensitive) != nil
                }
                onMoviesUpdated?()
                return
            }
            svc.searchMovies(query: query)
        }
        searchDebounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: workItem)
    }


    func loadFavoriteMovies() {
        favoriteMovies = favoriteMoviesManager.loadFavoriteMovies()
        onFavoritesUpdated?()
    }

    func addFavorite(movie: Movie) {
        guard !favoriteMovies.contains(where: { $0.id == movie.id }) else { return }
        favoriteMovies.append(movie)
        favoriteMoviesManager.saveFavoriteMovies(favoriteMovies)
        onFavoritesUpdated?()
    }

    func removeFavorite(at index: Int) {
        guard favoriteMovies.indices.contains(index) else { return }
        favoriteMovies.remove(at: index)
        favoriteMoviesManager.saveFavoriteMovies(favoriteMovies)
        onFavoritesUpdated?()
    }

    @discardableResult
    func toggleFavorite(movie: Movie) -> Bool {
        var favs = favoriteMoviesManager.loadFavoriteMovies()
        guard let idx = favs.firstIndex(where: { $0.id == movie.id }) else {
            favs.append(movie)
            favoriteMovies = favs
            favoriteMoviesManager.saveFavoriteMovies(favs)
            onFavoritesUpdated?()
            return true
        }
        
        favs.remove(at: idx)
        favoriteMovies = favs
        favoriteMoviesManager.saveFavoriteMovies(favs)
        onFavoritesUpdated?()
        return false
    }

    func formattedRating(for movie: Movie) -> String {
        "⭐️ \(String(format: "%.1f", movie.voteAverage))"
    }

    func isFavorite(movie: Movie) -> Bool {
        favoriteMovies.contains { $0.id == movie.id }
    }

    func loadImage(for movie: Movie, completion: @escaping (UIImage?) -> Void) {
        let urlString = "https://image.tmdb.org/t/p/w200\(movie.posterPath)"
        movieService.loadImage(from: urlString, completion: completion)
    }
}

extension MoviesViewModel: MovieServiceDelegate {
    func didFetchMovies(_ movies: [Movie]) {
        DispatchQueue.main.async {
            self.cacheMovies(movies)
            self.movies = movies
            self.filteredMovies = movies
            self.onMoviesUpdated?()
        }
    }
    
    func didFailWithError(_ error: MovieServiceError) {
        DispatchQueue.main.async {
            self.onError?(error.localizedDescription)
        }
    }
}
