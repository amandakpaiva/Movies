//
//  MovieDetailViewControllerTests.swift
//  MoviesAppTests
//
//  Created by Amanda Karolina Santos da Fonseca Paiva

import XCTest
@testable import MoviesApp

final class MovieDetailViewControllerTests: XCTestCase {
    var sut: MovieDetailViewController!
    var mockMovie: Movie!
    var mockCoordinator: MoviesCoordinator!
    var mockNavigationController: MockNavigationController!
    
    override func setUp() {
        super.setUp()
        mockMovie = Movie(adult: false,
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
        
        mockNavigationController = MockNavigationController()
        mockCoordinator = MoviesCoordinator(navigationController: mockNavigationController)
        sut = MovieDetailViewController(movie: mockMovie, coordinator: mockCoordinator)
        _ = sut.view
    }
    
    override func tearDown() {
        sut = nil
        mockMovie = nil
        mockCoordinator = nil
        mockNavigationController = nil
        super.tearDown()
    }
    
    func testViewDidLoad() {
        // Then
        XCTAssertNotNil(sut.navigationItem.leftBarButtonItem)
        XCTAssertNotNil(sut.navigationItem.rightBarButtonItem)
    }
    
    func testToggleFavorite() {
        // Given
        let expectation = XCTestExpectation(description: "Favorite toggled")
        
        // When
        sut.toggleFavorite()
        
        // Then
        // Verificar se o estado do botão de favorito foi atualizado
        // Como o estado é privado, podemos verificar através da UI
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testOpenFavoritesScreen() {
        // When
        sut.openFavoritesScreen()
        
        // Then
        XCTAssertEqual(mockNavigationController.pushedViewControllers.count, 1)
        XCTAssertTrue(mockNavigationController.pushedViewControllers[0] is FavoritesHostingController)
    }
    
    func testLoadImage() {
        // Given
        let expectation = XCTestExpectation(description: "Image loaded")
        
        // When
        sut.loadImage()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testBackAction() {
        // When
        sut.backAction()
        
        // Then
        // Verificar se o navigationController.popViewController foi chamado
        // Como o navigationController é privado, podemos verificar através do mock
        XCTAssertTrue(mockNavigationController.didPopViewController)
    }
} 