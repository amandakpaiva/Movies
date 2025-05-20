//
//  MoviesCoordinatorTests.swift
//  MoviesAppTests
//
//  Created by Amanda Karolina Santos da Fonseca Paiva on 07/02/25.
//

import Foundation

import XCTest
@testable import MoviesApp

final class MoviesCoordinatorTests: XCTestCase {
    var coordinator: MoviesCoordinator!
    var mockNavigationController: MockNavigationController!
    
    override func setUp() {
        super.setUp()
        mockNavigationController = MockNavigationController()
        coordinator = MoviesCoordinator(navigationController: mockNavigationController)
    }
    
    override func tearDown() {
        coordinator = nil
        mockNavigationController = nil
        super.tearDown()
    }
    
    func testStart() {
        coordinator.start()
        
        XCTAssertEqual(mockNavigationController.pushedViewControllers.count, 1)
        XCTAssertTrue(mockNavigationController.pushedViewControllers[0] is MoviesViewController)
    }
    
    func testShowMovieDetail() {
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
        
        coordinator.showMovieDetail(movie: movie)
        
        XCTAssertEqual(mockNavigationController.pushedViewControllers.count, 1)
        XCTAssertTrue(mockNavigationController.pushedViewControllers[0] is MovieDetailViewController)
    }
    
    func testNavigateToFavorites() {
        coordinator.navigateToFavorites()
        
        XCTAssertEqual(mockNavigationController.pushedViewControllers.count, 1)
        XCTAssertTrue(mockNavigationController.pushedViewControllers[0] is FavoritesHostingController)
    }
}
