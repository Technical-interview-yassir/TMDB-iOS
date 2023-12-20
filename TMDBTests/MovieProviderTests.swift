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

    func test_prepareTrendingMoviesURL_success() {
        let sut = movieProvider.prepareTrendingMoviesURL()
        XCTAssertEqual(sut?.absoluteString, "https://api.themoviedb.org/3/discover/movie")
    }

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

    func test_trendingMovies_decoder() throws {
        let sut = movieProvider.decoder

        let testBundle = Bundle(for: type(of: self))
        let url: URL! = testBundle.url(forResource: "DiscoverMovieResponse", withExtension: "json")
        let data = try Data(contentsOf: url)

        let result = try sut.decode(DiscoverResult.self, from: data)

        XCTAssertEqual(result.page, 1)
        XCTAssertEqual(result.totalPages, 41572)
        XCTAssertEqual(result.totalResults, 831437)
        XCTAssertEqual(result.results.first?.id, 787699)
    }
}
