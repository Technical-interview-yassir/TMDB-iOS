//
//  MovieProviderTests.swift
//  TMDBTests
//
//  Created by Maxime Bentin on 20.12.23.
//

import Foundation
import XCTest

@testable import TMDB

struct SecretManagerMock: SecretManagable {
    func readTMDBAccessToken(file _: URL) -> String {
        "Mocked"
    }
}

final class HTTPMovieProviderTests: XCTestCase {

    var movieProvider: HTTPMovieProvider!

    override func setUp() async throws {
        movieProvider = HTTPMovieProvider(secretManager: SecretManagerMock())
    }

    // MARK: URL preparations

    func test_prepareTrendingMoviesURL_success() {
        let sut = movieProvider.prepareDiscovergMoviesURL(page: 1)
        XCTAssertEqual(sut?.absoluteString, "https://api.themoviedb.org/3/discover/movie?page=1")
    }

    func test_prepareFetchConfigurationURL_success() throws {
        let sut = try movieProvider.prepareFetchConfigurationURL()
        XCTAssertEqual(sut.absoluteString, "https://api.themoviedb.org/3/configuration")
    }

    func test_preparePosterURL_success() async throws {
        movieProvider.configuration = .init(images: .init(baseURL: "baseURL", posterSizes: ["Size1", "Size2"]))
        let sut = try await movieProvider.preparePosterURL(path: "fakePath", imageQuality: .low)
        XCTAssertEqual(sut.absoluteString, "baseURL/Size1/fakePath")
    }
    
    func test_preparePosterURL_highQuality() async throws {
        movieProvider.configuration = .init(images: .init(baseURL: "baseURL", posterSizes: ["Size1", "Size2"]))
        let sut = try await movieProvider.preparePosterURL(path: "fakePath", imageQuality: .high)
        XCTAssertEqual(sut.absoluteString, "baseURL/Size2/fakePath")
    }

    func test_preparePosterURL_noConfiguration_throws() async throws {
        movieProvider.configuration = nil
        do {
            _ = try await movieProvider.preparePosterURL(path: "fakePath", imageQuality: .low)
        } catch {
            XCTAssertEqual(error as? MovieProvdiderError, .configurationFetchFailed)
        }
    }

    // MARK: Request preparations

    func test_prepareRequest_success() throws {
        let url: URL! = URL(string: "http://valid.url")
        let sut = try movieProvider.prepareRequest(url: url)
        XCTAssertEqual(sut.url?.absoluteString, "http://valid.url")
        XCTAssertEqual(
            sut.allHTTPHeaderFields,
            [
                "Accept": "application/json",
                "Authorization": "Bearer Mocked",
            ]
        )
        XCTAssertEqual(sut.httpMethod, "GET")
    }

    // MARK: Decoding

    func dataFromJSON(resource: String) throws -> Data {
        let testBundle = Bundle(for: type(of: self))
        let url: URL! = testBundle.url(forResource: resource, withExtension: "json")
        return try Data(contentsOf: url)
    }

    func test_trendingMovies_decoder() throws {
        let decoder = movieProvider.decoder

        let data = try dataFromJSON(resource: "DiscoverMovieResponse")
        let sut = try decoder.decode(DiscoverResult.self, from: data)

        XCTAssertEqual(sut.page, 1)
        XCTAssertEqual(sut.totalPages, 41572)
        XCTAssertEqual(sut.totalResults, 831437)
        XCTAssertEqual(sut.results.first?.id, 787699)
    }

    func test_configuration_decoder() throws {
        let decoder = movieProvider.decoder
        let data = try dataFromJSON(resource: "ConfigurationResponse")
        let sut = try decoder.decode(Configuration.self, from: data)

        XCTAssertEqual(sut.images.baseURL, "https://image.tmdb.org/t/p/")
        XCTAssertEqual(sut.images.posterSizes.count, 7)
    }
}
