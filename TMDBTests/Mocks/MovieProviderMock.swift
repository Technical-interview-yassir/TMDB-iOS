//
//  MovieProviderMock.swift
//  TMDBTests
//
//  Created by Maxime Bentin on 21.12.23.
//

import UIKit

@testable import TMDB

class MovieProviderMock: MovieProvider {
    var trendingMovies: [DiscoverMovie] = [.stub]

    func movieDetails(id: Int) async throws -> TMDB.MovieDetails {
        MovieDetails(id: 45, revenue: 100_000, budget: 5_000)
    }

    func trendingMovies(page: Int) async throws -> [DiscoverMovie] {
        trendingMovies
    }

    func poster(path: String, imageQuality: ImageQuality) async throws -> Data {
        guard let data = UIImage(systemName: "pencil")?.pngData() else {
            return Data()
        }
        return data
    }
}
