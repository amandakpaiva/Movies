//
//  MoviesViewControllerTests.swift
//  MoviesAppTests
//
//  Created by Amanda Karolina Santos da Fonseca Paiva

import XCTest
@testable import MoviesApp

final class MoviesViewControllerTests: XCTestCase {
    var sut: MoviesViewController!
    var mockViewModel: MoviesViewModel!
    var mockCoordinator: MoviesCoordinator!
    var mockNavigationController: MockNavigationController!
    
    override func setUp() {
        super.setUp()
        mockViewModel = MoviesViewModel()
        mockNavigationController = MockNavigationController()
        mockCoordinator = MoviesCoordinator(navigationController: mockNavigationController)
        sut = MoviesViewController(viewModel: mockViewModel, coordinator: mockCoordinator)
        _ = sut.view
    }
    
    override func tearDown() {
        sut = nil
        mockViewModel = nil
        mockCoordinator = nil
        mockNavigationController = nil
        super.tearDown()
    }
    
    func testViewDidLoad() {
        // Then
        XCTAssertEqual(sut.title, "movies_title".localized)
        XCTAssertNotNil(sut.navigationItem.rightBarButtonItem)
        XCTAssertNotNil(sut.navigationItem.titleView)
    }
    
    func testShowFavorites() {
        // When
        sut.showFavorites()
        
        // Then
        XCTAssertEqual(mockNavigationController.pushedViewControllers.count, 1)
        XCTAssertTrue(mockNavigationController.pushedViewControllers[0] is FavoritesHostingController)
    }
    
    func testRefreshMovies() {
        // Given
        let expectation = XCTestExpectation(description: "Movies updated")
        mockViewModel.onMoviesUpdated = {
            expectation.fulfill()
        }
        
        // When
        sut.refreshMovies()
        
        // Then
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testSearchBarDelegate() {
        // Given
        let searchBar = UISearchBar()
        
        // When
        sut.searchBar(searchBar, textDidChange: "test")
        
        // Then
        // Verificar se o viewModel foi chamado com o texto correto
        // Como o viewModel é privado, podemos verificar o comportamento indiretamente
        // através do estado da UI ou através de um mock do viewModel
    }
    
    func testTableViewDataSource() {
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
        mockViewModel.filteredMovies = [movie]
        sut.tableView.reloadData()
        
        // Then
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
        
        let cell = sut.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MovieCell
        XCTAssertNotNil(cell)
    }
    
    func testTableViewDelegate() {
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
        mockViewModel.filteredMovies = [movie]
        sut.tableView.reloadData()
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        // Then
        XCTAssertEqual(mockNavigationController.pushedViewControllers.count, 1)
        XCTAssertTrue(mockNavigationController.pushedViewControllers[0] is MovieDetailViewController)
    }
} 