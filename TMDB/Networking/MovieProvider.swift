//
//  MovieProvider.swift
//  TMDB
//
//  Created by Maxime Bentin on 20.12.23.
//

import Foundation

protocol MovieProvider {
    func trendingMovies() async throws -> [DiscoverMovie]
}

enum MovieProvdiderError: Error {
    case plistNotFound
}

struct HTTPMovieProvider: MovieProvider {
    let baseURL = URL(string: "https://api.themoviedb.org/3/")
    let decoder: JSONDecoder
    let secretManager: SecretManagable

    init(secretManager: SecretManagable) {
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.customTMDB())
        self.secretManager = secretManager
    }

    func prepareTrendingMoviesURL() -> URL? {
        guard var baseURL else { return nil }
        baseURL.append(path: "discover/movie")

        return baseURL
    }

    func prepareRequest(url: URL) throws -> URLRequest {
        guard let secrets = Bundle.main.url(forResource: "Secrets", withExtension: "plist") else {
            throw MovieProvdiderError.plistNotFound
        }
        let accessToken = secretManager.readTMDBAccessToken(file: secrets)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["accept": "application/json", "Authorization": "Bearer \(accessToken)"]
        return request
    }

    func trendingMovies() async throws -> [DiscoverMovie] {
        guard let url = prepareTrendingMoviesURL() else { return [] }
        let request = try prepareRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try decoder.decode(DiscoverResult.self, from: data)

        return result.results
    }
}
