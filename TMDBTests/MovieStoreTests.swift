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
    func test_load_merging_success() async throws {
        let movieProviderMock = MovieProviderMock()
        movieProviderMock.trendingMovies = [
            .stub(id: 50),
            .stub(id: 12),
        ]
        let store = MovieStore(movieProvider: movieProviderMock)

        store.movies = [
            1: .stub(id: 1, title: "Wonka")
        ]

        // SUT
        await store.load()

        XCTAssertEqual(store.movies.count, 3)
        XCTAssertEqual(store.movies.keys.first, 1)
        XCTAssertEqual(store.movies.keys.last, 12)
    }

    @MainActor
    func test_load_merging_conflict() async throws {
        let movieProviderMock = MovieProviderMock()
        movieProviderMock.trendingMovies = [
            .stub(id: 1, title: "BadTitle"),
            .stub(id: 12),
        ]
        let store = MovieStore(movieProvider: movieProviderMock)

        store.movies = [
            1: .stub(id: 1, title: "Wonka")
        ]

        // SUT
        await store.load()

        XCTAssertEqual(store.movies.count, 2)
        XCTAssertEqual(store.movies[1]?.title, "Wonka")
    }

    @MainActor
    func test_addDetailsTo_success() async throws {
        let store = MovieStore(movieProvider: MovieProviderMock())
        store.movies[45] = .stub

        // SUT
        await store.addDetailsTo(id: 45)

        XCTAssertEqual(store.movies[45]?.profit, 95_000)
        XCTAssertNotNil(store.movies[45]?.image)
    }

    @MainActor
    func test_filteredMovies_empty() async throws {
        let store = MovieStore(movieProvider: MovieProviderMock())
        store.movies[45] = .stub(title: "Title")

        store.searchedText = "None"

        // SUT
        let sut = store.filteredMovies

        XCTAssertTrue(sut.isEmpty)
    }

    @MainActor
    func test_filteredMovies_results() async throws {
        let store = MovieStore(movieProvider: MovieProviderMock())
        store.movies[45] = .stub(title: "Title")

        store.searchedText = "Ti"

        // SUT
        let sut = store.filteredMovies

        XCTAssertEqual(sut.count, 1)
    }
}
