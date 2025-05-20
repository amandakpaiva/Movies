//
//  MovieServiceTests.swift
//  MoviesAppTests
//
//  Created by Amanda Karolina Santos da Fonseca Paiva on 07/02/25.
//

import XCTest
@testable import MoviesApp

// MARK: - URLProtocol Stub
class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (Data?, HTTPURLResponse, Error?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Handler não foi configurado.")
            return
        }
        
        do {
            let (data, response, error) = try handler(request)
            
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            if let error = error {
                client?.urlProtocol(self, didFailWithError: error)
            } else {
                client?.urlProtocolDidFinishLoading(self)
            }
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}

final class MovieServiceTests: XCTestCase {
    var sut: MovieService!
    var mockDelegate: MockServiceDelegate!
    
    override func setUp() {
        super.setUp()
        
        URLProtocol.registerClass(MockURLProtocol.self)
        
        sut = MovieService()
        mockDelegate = MockServiceDelegate()
        sut.delegate = mockDelegate
        
        UserDefaults.standard.removeObject(forKey: "cachedPopularMovies")
    }
    
    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        URLProtocol.unregisterClass(MockURLProtocol.self)
        
        UserDefaults.standard.removeObject(forKey: "cachedPopularMovies")
        
        sut = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func testFetchMoviesSuccess() {
        let expectation = XCTestExpectation(description: "Fetch movies")
        mockDelegate.expectation = expectation
        
        let mockMovie = Movie(adult: false,
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
        let mockResponsePayload = MoviesResponse(page: 1, results: [mockMovie])
        let mockData = try! JSONEncoder().encode(mockResponsePayload)
        
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (mockData, response, nil)
        }
        
        sut.fetchMovies()
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockDelegate.receivedMovies.count, 1)
        XCTAssertEqual(mockDelegate.receivedMovies.first?.id, mockMovie.id)
    }
    
    func testSearchMovies() {
        let expectation = XCTestExpectation(description: "Search movies")
        mockDelegate.expectation = expectation
        
        let mockMovie = Movie(adult: false,
                              backdropPath: "/path",
                              genreIds: [1],
                              id: 2,
                              originalLanguage: "en",
                              originalTitle: "SearchTest",
                              overview: "SearchTest",
                              popularity: 2.0,
                              posterPath: "/path",
                              releaseDate: "2024-02-02",
                              title: "SearchTest",
                              video: false,
                              voteAverage: 7.0,
                              voteCount: 50)
        let mockResponsePayload = MoviesResponse(page: 1, results: [mockMovie])
        let mockData = try! JSONEncoder().encode(mockResponsePayload)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (mockData, response, nil)
        }
        
        sut.searchMovies(query: "anything")
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockDelegate.receivedMovies.count, 1)
        XCTAssertEqual(mockDelegate.receivedMovies.first?.id, mockMovie.id)
    }
    
    func testLoadCachedMovies() {
        let expectation = XCTestExpectation(description: "Load cached movies")
        mockDelegate.expectation = expectation
        
        let testMovie = Movie(adult: false,
                              backdropPath: "/path",
                              genreIds: [1],
                              id: 3,
                              originalLanguage: "en",
                              originalTitle: "CacheTest",
                              overview: "CacheTest",
                              popularity: 3.0,
                              posterPath: "/path",
                              releaseDate: "2024-03-03",
                              title: "CacheTest",
                              video: false,
                              voteAverage: 6.0,
                              voteCount: 25)
        let cachedPayload = MoviesResponse(page: 1, results: [testMovie])
        let data = try! JSONEncoder().encode(cachedPayload)
        UserDefaults.standard.set(data, forKey: "cachedPopularMovies")
        
        sut.loadCachedMovies()
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockDelegate.receivedMovies.count, 1)
        XCTAssertEqual(mockDelegate.receivedMovies.first?.id, testMovie.id)
    }
}

class MockServiceDelegate: MovieServiceDelegate {
    var expectation: XCTestExpectation?
    var receivedMovies: [Movie] = []
    var receivedError: MovieServiceError?
    
    func didFetchMovies(_ movies: [Movie]) {
        receivedMovies = movies
        expectation?.fulfill()
    }
    
    func didFailWithError(_ error: MovieServiceError) {
        receivedError = error
        expectation?.fulfill()
    }
}
