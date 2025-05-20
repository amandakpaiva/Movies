//
//   MoviesViewControllerTests.swift
//  MoviesAppTests
//
//  Created by Amanda Karolina Santos da Fonseca Paiva on 07/02/25.
//

import Foundation
import XCTest
@testable import MoviesApp

final class MoviesViewControllerTests: XCTestCase {
    
    var viewController: MoviesViewController!
    var mockViewModel: MoviesViewModel!
    var mockCoordinator: MoviesCoordinator!
    var mockNavigationController = UINavigationController()
    override func setUp() {
        super.setUp()
        mockViewModel = MoviesViewModel()
        mockCoordinator = MoviesCoordinator(navigationController: mockNavigationController)
        viewController = MoviesViewController(viewModel: mockViewModel, coordinator: mockCoordinator)
        _ = viewController.view
    }
    
    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        mockCoordinator = nil
        super.tearDown()
    }
    
    func test_viewDidLoad_setsUpUI() {
        XCTAssertEqual(viewController.title, "movies_title".localized)
        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
    }
    
}
