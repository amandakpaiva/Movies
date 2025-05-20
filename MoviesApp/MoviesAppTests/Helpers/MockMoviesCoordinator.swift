//
//  MockMoviesCoordinator.swift
//  MoviesAppTests
//
//  Created by Amanda Karolina Santos da Fonseca Paiva on 07/02/25.
//

@testable import MoviesApp
import UIKit
// MARK: - Mock Classes
class MockMoviesCoordinator: MoviesCoordinator {
    var navigateToFavoritesCalled = false
    var showMovieDetailCalled = false
    
    override func navigateToFavorites() {
        navigateToFavoritesCalled = true
    }
    
    override func showMovieDetail(movie: Movie) {
        showMovieDetailCalled = true
    }
}
