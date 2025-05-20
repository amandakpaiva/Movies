//
//  AlertManagerTests.swift
//  MoviesAppTests
//
//  Created by Amanda Karolina Santos da Fonseca Paiva

import XCTest
@testable import MoviesApp
import UIKit


final class AlertManagerTests: XCTestCase {
    func testShowAlert() {
        let mockViewController = MockViewController()

        AlertManager.showAlert(on: mockViewController, title: "Teste", message: "Mensagem de teste")

        XCTAssertNotNil(mockViewController.presentedAlert, "Nenhum alerta foi apresentado")
        XCTAssertEqual(mockViewController.presentedAlert?.title, "Teste")
        XCTAssertEqual(mockViewController.presentedAlert?.message, "Mensagem de teste")
    }
}

final class MockViewController: UIViewController {
    var presentedAlert: UIAlertController?
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentedAlert = viewControllerToPresent as? UIAlertController
        completion?()
    }
}
