//
//  MockServiceDelegate.swift
//  MoviesAppTests
//
//  Created by Amanda Karolina Santos da Fonseca Paiva on 07/02/25.
//

import XCTest
@testable import MoviesApp

class MockMovieServiceDelegate: MovieServiceDelegate {
    var didFetchMoviesCalled = false
    var didFailWithErrorCalled = false
    var fetchedMovies: [Movie]?
    var error: MovieServiceError?

    func didFetchMovies(_ movies: [Movie]) {
        didFetchMoviesCalled = true
        fetchedMovies = movies
    }
    
    func didFailWithError(_ error: MovieServiceError) {
        didFailWithErrorCalled = true
        self.error = error
    }
}
