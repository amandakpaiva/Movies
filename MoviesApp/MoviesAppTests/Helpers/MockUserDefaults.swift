//
//  MockUserDefaults.swift
//  MoviesAppTests
//
//  Created by Amanda Karolina Santos da Fonseca Paiva on 07/02/25.
//

import Foundation

final class MockUserDefaults: UserDefaults {
    private var storage = [String: Any]()
    
    override func set(_ value: Any?, forKey defaultName: String) {
        storage[defaultName] = value
    }
    
    override func data(forKey defaultName: String) -> Data? {
        return storage[defaultName] as? Data
    }
}
