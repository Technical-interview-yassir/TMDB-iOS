//
//  PreviewMovieStore.swift
//  TMDB
//
//  Created by Maxime Bentin on 23.12.23.
//

import Foundation
import OrderedCollections

class PreviewMovieStore: MovieStore {
    init() {
        super.init(movieProvider: PreviewMovieProvider())
    }
    override func load() async {}

    @MainActor
    func set(movies: OrderedDictionary<Int, Movie>) async {
        self.movies = movies
    }
}

struct PreviewMovieProvider: MovieProvider {
    func movieDetails(id: Int) async throws -> MovieDetails {
        MovieDetails(id: 45, revenue: 50, budget: 30)
    }

    func trendingMovies(page: Int) async throws -> [DiscoverMovie] { [] }
    func poster(path: String, imageQuality: ImageQuality) async throws -> Data { Data() }
    func setup() async throws {}
}
