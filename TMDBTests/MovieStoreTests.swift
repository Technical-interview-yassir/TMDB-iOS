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
    func test_load_success() async throws {
        let store = MovieStore(movieProvider: MovieProviderMock())

        // SUT
        await store.load()

        XCTAssertEqual(store.movies.values.first?.id, 12)
        XCTAssertEqual(store.movies.values.first?.title, "Mocked")
        XCTAssertEqual(store.movies.values.first?.releaseDate, Date(timeIntervalSince1970: 1_234_567))
        XCTAssertNotNil(store.movies.values.first?.image)
    }

    @MainActor
    func test_addDetailsTo_success() async throws {
        let store = MovieStore(movieProvider: MovieProviderMock())
        store.movies[45] = .stub

        // SUT
        await store.addDetailsTo(id: 45)

        XCTAssertEqual(store.movies[45]?.profit, 95_000)
    }
}
