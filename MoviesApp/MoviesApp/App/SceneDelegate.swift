//
//  SceneDelegate.swift
//  MoviesApp
//
//  Created by Amanda Karolina Santos da Fonseca Paiva

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        let coordinator = MoviesCoordinator(navigationController: navigationController)
        let moviesViewController = MoviesViewController(viewModel: MoviesViewModel(), coordinator: coordinator)
        navigationController.viewControllers = [moviesViewController]
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
