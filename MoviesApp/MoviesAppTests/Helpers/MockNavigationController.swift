//
//  MockNavigationController.swift
//  MoviesAppTests
//
//  Created by Amanda Karolina Santos da Fonseca Paiva

import UIKit

class MockNavigationController: UINavigationController {
    var pushedViewControllers = [UIViewController]()
    var didPopViewController = false
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewControllers.append(viewController)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        didPopViewController = true
        return pushedViewControllers.popLast()
    }
}
