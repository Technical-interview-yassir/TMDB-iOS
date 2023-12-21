//
//  MovieProviderMock.swift
//  TMDBTests
//
//  Created by Maxime Bentin on 21.12.23.
//

import UIKit

@testable import TMDB

class MovieProviderMock: MovieProvider {
    func trendingMovies() async throws -> [DiscoverMovie] {
        [.stub]
    }

    func poster(path: String) async throws -> Data {
        guard let data = UIImage(systemName: "pencil")?.pngData() else {
            return Data()
        }
        return data
    }
}
