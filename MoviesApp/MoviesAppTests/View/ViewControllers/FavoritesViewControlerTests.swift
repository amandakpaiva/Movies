//
//  FavoritesViewControlerTests.swift
//  MoviesAppTests
//
//  Created by Amanda Karolina Santos da Fonseca Paiva on 07/02/25.
//

import XCTest
import SwiftUI
@testable import MoviesApp

final class FavoritesViewControllerTests: XCTestCase {

    var viewModel: MoviesViewModel!
    var coordinator: MoviesCoordinator!
    var hostingController: FavoritesHostingController!

    override func setUp() {
        super.setUp()
        viewModel = MoviesViewModel()
        coordinator = MoviesCoordinator(navigationController: UINavigationController())
        hostingController = FavoritesHostingController(coordinator: coordinator)

        let nav = UINavigationController(rootViewController: hostingController)
        nav.loadViewIfNeeded()
    }

    override func tearDown() {
        hostingController = nil
        viewModel = nil
        coordinator = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testRemoveFavoriteViaViewModel() {
        let demo = Movie(
            adult: false,
            backdropPath: "/path/back",
            genreIds: [],
            id: 1,
            originalLanguage: "en",
            originalTitle: "Demo",
            overview: "overview",
            popularity: 0,
            posterPath: "/path/poster",
            releaseDate: "2025-01-01",
            title: "Demo",
            video: false,
            voteAverage: 8.0,
            voteCount: 10
        )
        viewModel.favoriteMovies = [demo]

        viewModel.removeFavorite(at: 0)

        // Assert
        XCTAssertTrue(viewModel.favoriteMovies.isEmpty, "O filme deveria ter sido removido do array de favoritos.")
    }
}
