import XCTest
import SwiftUI
@testable import MoviesApp

final class FavoritesViewTests: XCTestCase {
    var sut: FavoritesView!
    var mockViewModel: MockMoviesViewModel!
    var mockOnSelect: ((Movie) -> Void)!
    var mockMovie: Movie!
    
    override func setUp() {
        super.setUp()
        mockViewModel = MockMoviesViewModel()
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
        mockOnSelect = { _ in }
        sut = FavoritesView(viewModel: mockViewModel, onSelect: mockOnSelect)
    }
    
    override func tearDown() {
        sut = nil
        mockViewModel = nil
        mockMovie = nil
        mockOnSelect = nil
        super.tearDown()
    }
    
    // MARK: - Empty State Tests
    
    func testEmptyState() {
        // Given
        mockViewModel.favoriteMovies = []
        
        // When
        let view = sut.body
        
        // Then
        XCTAssertNotNil(view)
    }
    
    // MARK: - List Tests
    
    func testListWithFavorites() {
        // Given
        mockViewModel.favoriteMovies = [mockMovie]
        
        // When
        let view = sut.body
        
        // Then
        XCTAssertNotNil(view)
    }
    
    // MARK: - Favorite Management Tests
    
    func testRemoveFavorite() {
        // Given
        mockViewModel.favoriteMovies = [mockMovie]
        let expectation = XCTestExpectation(description: "Remove favorite")
        mockViewModel.onFavoritesUpdated = {
            expectation.fulfill()
        }
        
        // When
        mockViewModel.removeFavorite(at: 0)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockViewModel.didCallRemoveFavorite)
        XCTAssertEqual(mockViewModel.lastRemovedIndex, 0)
    }
    
    // MARK: - Navigation Tests
    
    func testMovieSelection() {
        // Given
        mockViewModel.favoriteMovies = [mockMovie]
        var selectedMovie: Movie?
        let expectation = XCTestExpectation(description: "Select movie")
        
        // When
        mockOnSelect = { movie in
            selectedMovie = movie
            expectation.fulfill()
        }
        sut = FavoritesView(viewModel: mockViewModel, onSelect: mockOnSelect)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(selectedMovie?.id, mockMovie.id)
    }
    
    // MARK: - UI Tests
    
    func testFormattedRating() {
        // Given
        let rating = 8.5
        
        // When
        let formattedRating = mockViewModel.formattedRating(for: mockMovie)
        
        // Then
        XCTAssertEqual(formattedRating, "⭐️ 8.5")
    }
    
    // MARK: - Hosting Controller Tests
    
    func testFavoritesHostingController() {
        // Given
        let mockCoordinator = MockMoviesCoordinator(navigationController: UINavigationController())
        
        // When
        let hostingController = FavoritesHostingController(coordinator: mockCoordinator)
        
        // Then
        XCTAssertNotNil(hostingController)
        XCTAssertNotNil(hostingController.rootView)
    }
}

// MARK: - Mock Classes

class MockMoviesViewModel: MoviesViewModel {
    var didCallRemoveFavorite = false
    var lastRemovedIndex: Int?
    
    override func removeFavorite(at index: Int) {
        didCallRemoveFavorite = true
        lastRemovedIndex = index
        super.removeFavorite(at: index)
    }
} 