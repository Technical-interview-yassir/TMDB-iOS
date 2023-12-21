//
//  MovieStoreTests.swift
//  TMDBTests
//
//  Created by Maxime Bentin on 21.12.23.
//

import XCTest

@testable import TMDB

final class MovieStoreTests: XCTestCase {
    @MainActor
    func test_load() async throws {
        let store = MovieStore(movieProvider: MovieProviderMock())

        // SUT
        await store.load()

        XCTAssertEqual(store.movies.first?.id, 12)
        XCTAssertEqual(store.movies.first?.title, "Mocked")
        XCTAssertEqual(store.movies.first?.releaseDate, Date(timeIntervalSince1970: 1_234_567))
        XCTAssertNotNil(store.movies.first?.image)
    }
}
