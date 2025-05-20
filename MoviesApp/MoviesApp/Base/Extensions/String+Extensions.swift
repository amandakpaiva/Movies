//
//  String+Extensions.swift
//  MoviesApp
//
//  Created by Amanda Karolina Santos da Fonseca Paiva

import Foundation
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
