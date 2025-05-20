//
//  MovieDetailViewControllerTests.swift
//  MoviesAppTests
//
//  Created by Amanda Karolina Santos da Fonseca Paiva

import XCTest
@testable import MoviesApp

final class MovieDetailViewControllerTests: XCTestCase {
    var sut: MovieDetailViewController!
    var mockViewModel: MockMoviesViewModel!
    var mockCoordinator: MockMoviesCoordinator!
    var mockMovie: Movie!
    
    override func setUp() {
        super.setUp()
        mockViewModel = MockMoviesViewModel()
        mockCoordinator = MockMoviesCoordinator(navigationController: UINavigationController())
        mockMovie = Movie(
            adult: false,
            backdropPath: "/path/to/backdrop",
            genreIds: [1, 2, 3],
            id: 1,
            originalLanguage: "en",
            originalTitle: "Test Movie",
            overview: "Test Overview",
            popularity: 8.5,
            posterPath: "/path/to/poster",
            releaseDate: "2024-01-01",
            title: "Test Movie",
            video: false,
            voteAverage: 8.5,
            voteCount: 1000
        )
        
        sut = MovieDetailViewController(movie: mockMovie, coordinator: mockCoordinator)
        sut.viewModel = mockViewModel
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        mockViewModel = nil
        mockCoordinator = nil
        mockMovie = nil
        super.tearDown()
    }
    
    // MARK: - View Lifecycle Tests
    
    func testViewDidLoad() {
        // Then
        XCTAssertNotNil(sut.view)
        XCTAssertEqual(sut.title, mockMovie.title)
        XCTAssertNotNil(sut.navigationItem.leftBarButtonItem)
        XCTAssertNotNil(sut.navigationItem.rightBarButtonItem)
    }
    
    // MARK: - UI Tests
    
    func testMovieImageViewConfiguration() {
        // Then
        XCTAssertNotNil(sut.movieImageView)
        XCTAssertEqual(sut.movieImageView.contentMode, .scaleAspectFill)
        XCTAssertTrue(sut.movieImageView.clipsToBounds)
        XCTAssertEqual(sut.movieImageView.layer.cornerRadius, 16)
    }
    
    // MARK: - Favorite Functionality Tests
    
    func testToggleFavorite() {
        // Given
        let expectation = XCTestExpectation(description: "Toggle favorite")
        mockViewModel.onFavoritesUpdated = {
            expectation.fulfill()
        }
        
        // When
        sut.toggleFavorite()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockViewModel.didCallToggleFavorite)
        XCTAssertEqual(mockViewModel.lastToggledMovie?.id, mockMovie.id)
    }
    
    func testCheckIfFavorite() {
        // Given
        mockViewModel.isFavoriteResult = true
        
        // When
        sut.checkIfFavorite()
        
        // Then
        XCTAssertTrue(mockViewModel.didCallIsFavorite)
        XCTAssertEqual(mockViewModel.lastCheckedMovie?.id, mockMovie.id)
    }
    
    // MARK: - Navigation Tests
    
    func testOpenFavoritesScreen() {
        // When
        sut.openFavoritesScreen()
        
        // Then
        XCTAssertTrue(mockCoordinator.navigateToFavoritesCalled)
    }
    
    func testBackButtonAction() {
        // Given
        let expectation = XCTestExpectation(description: "Pop view controller")
        
        // When
        sut.navigationItem.leftBarButtonItem?.perform(mockCoordinator.navigationController)
        
        // Then
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Image Loading Tests
    
    func testLoadImage() {
        // Given
        let expectation = XCTestExpectation(description: "Load image")
        let mockImage = UIImage()
        mockViewModel.mockImage = mockImage
        
        // When
        sut.loadImage()
        
        // Then
        DispatchQueue.main.async {
            XCTAssertEqual(self.sut.movieImageView.image, mockImage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadImageFailure() {
        // Given
        let expectation = XCTestExpectation(description: "Load image failure")
        mockViewModel.mockImage = nil
        
        // When
        sut.loadImage()
        
        // Then
        DispatchQueue.main.async {
            XCTAssertNil(self.sut.movieImageView.image)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - Mock Classes

class MockMoviesViewModel: MoviesViewModel {
    var didCallToggleFavorite = false
    var didCallIsFavorite = false
    var lastToggledMovie: Movie?
    var lastCheckedMovie: Movie?
    var isFavoriteResult = false
    var mockImage: UIImage?
    
    override func toggleFavorite(movie: Movie) -> Bool {
        didCallToggleFavorite = true
        lastToggledMovie = movie
        return true
    }
    
    override func isFavorite(movie: Movie) -> Bool {
        didCallIsFavorite = true
        lastCheckedMovie = movie
        return isFavoriteResult
    }
    
    override func loadImage(for movie: Movie, completion: @escaping (UIImage?) -> Void) {
        completion(mockImage)
    }
} 