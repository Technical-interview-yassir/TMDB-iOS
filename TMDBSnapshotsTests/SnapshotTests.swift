//
//  ContentViewTests.swift
//  TMDBUITests
//
//  Created by Maxime Bentin on 22.12.23.
//

import OrderedCollections
import SnapshotTesting
import SwiftUI
import XCTest

@testable import TMDB

final class SnapshotTests: XCTestCase {
    func test_MovieCard() throws {
        let view = MovieCard(movie: .init(id: 12, title: "title", releaseDate: Date(), poster: "poster"))

        assertSnapshot(
            matching: view.wrappedViewController,
            as: .image(on: .iPhoneSe)
        )
    }

    @MainActor
    func test_ContentView() async {
        let movieStore = PreviewMovieStore()

        let movies: OrderedDictionary<Int, Movie> = [
            1: Movie(
                id: 1,
                title: "Wonka",
                releaseDate: Date(timeIntervalSince1970: 321_543_876),
                poster: "poster",
                image: Image(systemName: "pencil")
            ),
            2: Movie(
                id: 2,
                title: "Ant man",
                releaseDate: Date(timeIntervalSince1970: 3_215_432_133),
                poster: "poster",
                image: Image(systemName: "eraser")
            ),
        ]

        await movieStore.set(movies: movies)
        let view = ContentView(movieStore: movieStore)

        assertSnapshot(
            matching: view.wrappedViewController,
            as: .image(on: .iPhoneSe)
        )
    }

    func test_MovieDetailsView() throws {
        let view = MovieDetailsView(
            movieStore: PreviewMovieStore(),
            movie: Movie(
                id: 2,
                title: "Ant man",
                releaseDate: Date(timeIntervalSince1970: 3_215_432_133),
                poster: "poster",
                image: Image(systemName: "eraser"),
                profit: 500_000
            )
        )

        assertSnapshot(
            matching: view.wrappedViewController,
            as: .image(on: .iPhoneSe)
        )
    }
}

extension View {
    var wrappedViewController: UIViewController {
        UIHostingController(rootView: self)
    }
}
