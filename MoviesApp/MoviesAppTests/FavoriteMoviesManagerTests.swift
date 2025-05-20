//
//  FavoriteMoviesManagerTests.swift
//  MoviesAppTests
//
//  Created by Amanda Karolina Santos da Fonseca Paiva on 07/02/25.
//

import XCTest
@testable import MoviesApp

final class FavoriteMoviesManagerTests: XCTestCase {
    
    var sut: FavoriteMoviesManager!
    var mockUserDefaults: MockUserDefaults!
    
    override func setUp() {
        super.setUp()
        mockUserDefaults = MockUserDefaults()
        sut = FavoriteMoviesManager()

        UserDefaults.standard.removeObject(forKey: "favoriteMovies")
    }
    
    override func tearDown() {
        sut = nil
        mockUserDefaults = nil

        UserDefaults.standard.removeObject(forKey: "favoriteMovies")
        super.tearDown()
    }
    
    func testSaveAndLoadFavoriteMovies() {
        // Given
        let movie = Movie(adult: false,
                         backdropPath: "/path",
                         genreIds: [1],
                         id: 1,
                         originalLanguage: "en",
                         originalTitle: "Test",
                         overview: "Test",
                         popularity: 1.0,
                         posterPath: "/path",
                         releaseDate: "2024-01-01",
                         title: "Test",
                         video: false,
                         voteAverage: 8.0,
                         voteCount: 100)
        
        // When
        sut.saveFavoriteMovies([movie])
        let loadedMovies = sut.loadFavoriteMovies()
        
        // Then
        XCTAssertEqual(loadedMovies.count, 1)
        XCTAssertEqual(loadedMovies[0].id, movie.id)
        XCTAssertEqual(loadedMovies[0].title, movie.title)
    }
    
    func testIsMovieFavorite() {
        // Given
        let movie = Movie(adult: false,
                         backdropPath: "/path",
                         genreIds: [1],
                         id: 1,
                         originalLanguage: "en",
                         originalTitle: "Test",
                         overview: "Test",
                         popularity: 1.0,
                         posterPath: "/path",
                         releaseDate: "2024-01-01",
                         title: "Test",
                         video: false,
                         voteAverage: 8.0,
                         voteCount: 100)
        
        // When
        sut.saveFavoriteMovies([movie])
        
        // Then
        XCTAssertTrue(sut.isMovieFavorite(movie))
        
        // When
        let differentMovie = Movie(adult: false,
                                 backdropPath: "/path",
                                 genreIds: [1],
                                 id: 2,
                                 originalLanguage: "en",
                                 originalTitle: "Test2",
                                 overview: "Test2",
                                 popularity: 1.0,
                                 posterPath: "/path",
                                 releaseDate: "2024-01-01",
                                 title: "Test2",
                                 video: false,
                                 voteAverage: 8.0,
                                 voteCount: 100)
        
        // Then
        XCTAssertFalse(sut.isMovieFavorite(differentMovie))
    }
    
    func testLoadEmptyFavorites() {
        // Given
        UserDefaults.standard.removeObject(forKey: "favoriteMovies")
        
        // When
        let movies = sut.loadFavoriteMovies()
        
        // Then
        XCTAssertTrue(movies.isEmpty)
    }
}
