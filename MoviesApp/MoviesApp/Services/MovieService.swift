//
//  MovieService.swift
//  MoviesApp
//
//  Created by Amanda Karolina Santos da Fonseca Paiva
//


import UIKit
import Network

// MARK: - Protocols
protocol MovieServiceDelegate: AnyObject {
    func didFetchMovies(_ movies: [Movie])
    func didFailWithError(_ error: MovieServiceError)
}

protocol MovieServiceProtocol {
    var delegate: MovieServiceDelegate? { get set }
    func fetchMovies()
    func searchMovies(query: String)
    func loadCachedMovies()
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void)
}

// MARK: - Errors
enum MovieServiceError: Error {
    case invalidURL
    case noData
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
}

// MARK: - Service
final class MovieService: MovieServiceProtocol {
    // API
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey  = "eb4f29aea257ebd547d87bb44e676817"

    // Caches
    private var imageCache = NSCache<NSString, UIImage>()
    private let monitor    = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "NetworkMonitor")
    private(set) var isNetworkAvailable: Bool = true

    weak var delegate: MovieServiceDelegate?

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isNetworkAvailable = (path.status == .satisfied)
        }
        monitor.start(queue: monitorQueue)
    }

    // MARK: Fetch popular movies
    func fetchMovies() {
        let urlString = "\(baseURL)/movie/popular?api_key=\(apiKey)&language=pt-BR"
        guard let url = URL(string: urlString) else {
            delegate?.didFailWithError(.invalidURL)
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                self?.delegate?.didFailWithError(.requestFailed(error))
                return
            }

            guard let data = data else {
                self?.delegate?.didFailWithError(.noData)
                return
            }

            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                self?.delegate?.didFailWithError(.invalidResponse)
                return
            }

            do {
                let movies = try JSONDecoder().decode(MoviesResponse.self, from: data).results
                self?.cacheMovies(movies)
                self?.delegate?.didFetchMovies(movies)
            } catch {
                self?.delegate?.didFailWithError(.decodingError(error))
            }
        }.resume()
    }


    // MARK: Search movies
    func searchMovies(query: String) {
        Task {
            do {
                guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                      let url = URL(string: "\(baseURL)/search/movie?api_key=\(apiKey)&language=pt-BR&query=\(encoded)") else { return }

                let (data, response) = try await URLSession.shared.data(from: url)
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                    delegate?.didFailWithError(.invalidResponse); return
                }
                let movies = try JSONDecoder().decode(MoviesResponse.self, from: data).results
                delegate?.didFetchMovies(movies)
            } catch {
                delegate?.didFailWithError(.requestFailed(error))
            }
        }
    }

    // MARK: Image loader with in-memory cache
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cached = imageCache.object(forKey: urlString as NSString) {
            DispatchQueue.main.async { completion(cached) }
            return
        }
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async { completion(nil) }
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let img = UIImage(data: data) else {
                DispatchQueue.main.async { completion(nil) }; return
            }
            self?.imageCache.setObject(img, forKey: urlString as NSString)
            DispatchQueue.main.async { completion(img) }
        }.resume()
    }

    // MARK: Cache helpers
    func loadCachedMovies() {
        guard let data = UserDefaults.standard.data(forKey: "cachedPopularMovies"),
              let resp = try? JSONDecoder().decode(MoviesResponse.self, from: data) else { return }
        delegate?.didFetchMovies(resp.results)
    }

    private func cacheMovies(_ movies: [Movie]) {
        guard !movies.isEmpty,
              let data = try? JSONEncoder().encode(MoviesResponse(page: 1, results: movies)) else { return }
        UserDefaults.standard.set(data, forKey: "cachedPopularMovies")
    }
}
