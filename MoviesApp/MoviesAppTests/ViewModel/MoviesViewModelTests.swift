//
//  MoviesViewModelTests.swift
//  MoviesAppTests
//
//  Created by Amanda Karolina Santos da Fonseca Paiva

import XCTest
import UIKit

@testable import MoviesApp
class MoviesViewModelTests: XCTestCase {
    
    var viewModel: MoviesViewModel!
    var mockMovieService: MockMovieService!
    var mockFavoriteMoviesManager: MockFavoriteMoviesManager!
    
    override func setUp() {
        super.setUp()
        mockMovieService = MockMovieService()
        mockFavoriteMoviesManager = MockFavoriteMoviesManager()
        viewModel = MoviesViewModel(movieService: mockMovieService, favoriteMoviesManager: mockFavoriteMoviesManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockMovieService = nil
        mockFavoriteMoviesManager = nil
        super.tearDown()
    }
    
    func testLoadImage() {
        let expectation = self.expectation(description: "Image should be loaded")
        
        
        
        let movie = Movie(adult: false, backdropPath: "/path/to/backdrop", genreIds: [1, 2, 3], id: 1, originalLanguage: "en", originalTitle: "Inception", overview: "A mind-bending thriller", popularity: 80.5, posterPath: "/path/to/poster", releaseDate: "2010-07-16", title: "Inception", video: false, voteAverage: 8.8, voteCount: 10000)
        
        viewModel.loadImage(for: movie) { image in
            XCTAssertNotNil(image, "The image should not be nil")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testAddFavorite() {
        let movie = Movie(adult: false, backdropPath: "/path/to/backdrop", genreIds: [1, 2, 3], id: 2, originalLanguage: "en", originalTitle: "Titanic", overview: "A love story on the Titanic", popularity: 70.5, posterPath: "/path/to/poster", releaseDate: "1997-12-19", title: "Titanic", video: false, voteAverage: 7.8, voteCount: 9000)
        
        viewModel.addFavorite(movie: movie)
        
        XCTAssertEqual(viewModel.favoriteMovies.count, 1, "Favorite movies list should contain one movie")
        XCTAssertTrue(viewModel.favoriteMovies.contains { $0.id == movie.id }, "The movie should be in the favorites list")
    }
    
    func testRemoveFavorite() {
        let movie = Movie(adult: false, backdropPath: "/path/to/backdrop", genreIds: [1, 2, 3], id: 2, originalLanguage: "en", originalTitle: "Titanic", overview: "A love story on the Titanic", popularity: 70.5, posterPath: "/path/to/poster", releaseDate: "1997-12-19", title: "Titanic", video: false, voteAverage: 7.8, voteCount: 9000)
        
        viewModel.addFavorite(movie: movie)
        XCTAssertEqual(viewModel.favoriteMovies.count, 1, "Favorite movies list should contain one movie")
        
        viewModel.removeFavorite(at: 0)
        
        XCTAssertEqual(viewModel.favoriteMovies.count, 0, "Favorite movies list should be empty")
    }
    
    func testToggleFavorite() {
        let movie = Movie(adult: false, backdropPath: "/path/to/backdrop", genreIds: [1, 2, 3], id: 2, originalLanguage: "en", originalTitle: "Titanic", overview: "A love story on the Titanic", popularity: 70.5, posterPath: "/path/to/poster", releaseDate: "1997-12-19", title: "Titanic", video: false, voteAverage: 7.8, voteCount: 9000)
        
        let wasFavorite = viewModel.toggleFavorite(movie: movie)
        XCTAssertTrue(wasFavorite, "The movie should be added to the favorites list")
        
        let isFavorite = viewModel.isFavorite(movie: movie)
        XCTAssertTrue(isFavorite, "The movie should be in the favorites list")
        
        let wasUnfavorite = viewModel.toggleFavorite(movie: movie)
        XCTAssertFalse(wasUnfavorite, "The movie should be removed from the favorites list")
    }
    
    func testFormattedRating() {
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
        
        let formattedRating = viewModel.formattedRating(for: movie)
        XCTAssertEqual(formattedRating, "⭐️ 7.8", "The formatted rating should be '⭐️ 7.8'")
    }
}
