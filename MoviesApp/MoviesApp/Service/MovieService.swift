//
//  MovieService.swift
//  MoviesApp
//
//  Created by Amanda Karolina Santos da Fonseca Paiva

import Foundation
import UIKit

protocol MovieServiceDelegate: AnyObject {
    func didFetchMovies(_ movies: [Movie])
    func didFailWithError(_ error: MovieServiceError)
}

enum MovieServiceError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case decodingError
    case networkError(Error)
}

class MovieService {
    private let apiKey = "1d9c076a0c6e0a8c4d8c4c4c4c4c4c4c"
    private let baseURL = "https://api.themoviedb.org/3"
    private let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    private let session: URLSession
    
    weak var delegate: MovieServiceDelegate?
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchMovies() {
        let urlString = "\(baseURL)/movie/popular?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            delegate?.didFailWithError(.invalidURL)
            return
        }
        
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                self?.delegate?.didFailWithError(.networkError(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                self?.delegate?.didFailWithError(.invalidResponse)
                return
            }
            
            guard let data = data else {
                self?.delegate?.didFailWithError(.invalidData)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let moviesResponse = try decoder.decode(MoviesResponse.self, from: data)
                
                // Cache the movies
                UserDefaults.standard.set(data, forKey: "cachedPopularMovies")
                
                DispatchQueue.main.async {
                    self?.delegate?.didFetchMovies(moviesResponse.results)
                }
            } catch {
                self?.delegate?.didFailWithError(.decodingError)
            }
        }
        
        task.resume()
    }
    
    func searchMovies(query: String) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(encodedQuery)"
        
        guard let url = URL(string: urlString) else {
            delegate?.didFailWithError(.invalidURL)
            return
        }
        
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                self?.delegate?.didFailWithError(.networkError(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                self?.delegate?.didFailWithError(.invalidResponse)
                return
            }
            
            guard let data = data else {
                self?.delegate?.didFailWithError(.invalidData)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let moviesResponse = try decoder.decode(MoviesResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self?.delegate?.didFetchMovies(moviesResponse.results)
                }
            } catch {
                self?.delegate?.didFailWithError(.decodingError)
            }
        }
        
        task.resume()
    }
    
    func loadImage(from path: String, completion: @escaping (UIImage?) -> Void) {
        let urlString = "\(imageBaseURL)\(path)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error loading image: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        task.resume()
    }
    
    func loadCachedMovies() {
        guard let data = UserDefaults.standard.data(forKey: "cachedPopularMovies") else {
            delegate?.didFetchMovies([])
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let moviesResponse = try decoder.decode(MoviesResponse.self, from: data)
            delegate?.didFetchMovies(moviesResponse.results)
        } catch {
            delegate?.didFailWithError(.decodingError)
        }
    }
} 