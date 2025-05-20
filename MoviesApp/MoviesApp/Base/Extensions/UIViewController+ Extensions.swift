//
//  UIViewController+Extensions.swift
//  MoviesApp
//
//  Created by Amanda Karolina Santos da Fonseca Paiva

import UIKit

extension UIViewController {
    func createHeartButton(title: String, target: Any, action: Selector) -> UIBarButtonItem {
        let heartImage = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        let heartButton = UIButton(type: .custom)
        heartButton.setImage(heartImage, for: .normal)
        heartButton.setTitle(" \(title)", for: .normal)
        heartButton.setTitleColor(.red, for: .normal)
        heartButton.addTarget(target, action: action, for: .touchUpInside)
        heartButton.sizeToFit()
        
        return UIBarButtonItem(customView: heartButton)
    }
    
    
    func createBackButton(title: String) -> UIBarButtonItem {
        return UIBarButtonItem(
            title: title,
            style: .plain,
            target: self,
            action: #selector(backAction)
        )
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
}
