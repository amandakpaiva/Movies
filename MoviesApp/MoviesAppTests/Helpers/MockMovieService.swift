//
//  MockMovieService.swift
//  MoviesAppTests
//
//  Created by Amanda Karolina Santos da Fonseca Paiva

import UIKit
@testable import MoviesApp

class MockMovieService: MovieServiceProtocol {

    private(set) var didCallFetch  = false
    private(set) var didCallSearch = false
    private(set) var didCallLoadCachedMovies = false
    private(set) var lastSearchQuery: String?

    weak var delegate: MovieServiceDelegate?

    // MARK: - Implementações simuladas
    func fetchMovies() {
        didCallFetch = true


        let movie = Movie(
            adult: false,
            backdropPath: "/path/to/backdrop",
            genreIds: [1, 2, 3],
            id: 2,
            originalLanguage: "en",
            originalTitle: "Titanic",
            overview: "A love story on the Titanic",
            popularity: 70.5,
            posterPath: "/path/to/poster",
            releaseDate: "1997-12-19",
            title: "Titanic",
            video: false,
            voteAverage: 7.8,
            voteCount: 9000
        )
        delegate?.didFetchMovies([movie])
    }

    func searchMovies(query: String) {
        didCallSearch   = true
        lastSearchQuery = query

        let result = Movie(
            adult: false,
            backdropPath: "/path/back",
            genreIds: [12],
            id: 3,
            originalLanguage: "en",
            originalTitle: "Avatar",
            overview: "Sci-fi adventure",
            popularity: 90.0,
            posterPath: "/poster/avatar",
            releaseDate: "2009-12-18",
            title: "Avatar",
            video: false,
            voteAverage: 7.4,
            voteCount: 11000
        )
        delegate?.didFetchMovies([result])
    }

    func loadCachedMovies() {
        didCallLoadCachedMovies = true

        delegate?.didFetchMovies([])
    }

    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        completion(UIImage())
    }
}
