//
//  MovieProvider.swift
//  TMDB
//
//  Created by Maxime Bentin on 20.12.23.
//

import Foundation
import SwiftUI

protocol MovieProvider {
    func trendingMovies() async throws -> [DiscoverMovie]
    func poster(path: String) async throws -> Data
}

enum MovieProvdiderError: Error {
    case plistNotFound
    case invalidBaseURL
    case configurationFetchFailed
}

class HTTPMovieProvider: MovieProvider {
    let baseURL = URL(string: "https://api.themoviedb.org/3")
    let decoder: JSONDecoder
    let secretManager: SecretManagable
    var configuration: Configuration? = nil

    func getAccessToken() throws -> String {
        guard let secrets = Bundle.main.url(forResource: "Secrets", withExtension: "plist") else {
            throw MovieProvdiderError.plistNotFound
        }
        return secretManager.readTMDBAccessToken(file: secrets)
    }

    init(secretManager: SecretManagable) {
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.customTMDB())
        self.secretManager = secretManager
    }

    func setup() async throws {
        if configuration == nil {
            configuration = try await fetchConfiguration()
        }
    }

    func prepareTrendingMoviesURL() -> URL? {
        guard var baseURL else { return nil }
        baseURL.append(path: "discover/movie")

        return baseURL
    }

    func prepareRequest(url: URL) throws -> URLRequest {
        let accessToken = try getAccessToken()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(accessToken)",
        ]
        return request
    }

    func trendingMovies() async throws -> [DiscoverMovie] {
        guard let url = prepareTrendingMoviesURL() else { return [] }
        let request = try prepareRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try decoder.decode(DiscoverResult.self, from: data)

        return result.results
    }

    func prepareFetchConfigurationURL() throws -> URL {
        guard var baseURL else { throw MovieProvdiderError.invalidBaseURL }
        baseURL.append(path: "configuration")
        return baseURL
    }

    func fetchConfiguration() async throws -> Configuration {
        let url = try prepareFetchConfigurationURL()
        let request = try prepareRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try decoder.decode(Configuration.self, from: data)

        return result
    }

    func preparePosterURL(path: String) async throws -> URL {
        guard let configuration else { throw MovieProvdiderError.configurationFetchFailed }
        guard let baseURL = URL(string: configuration.images.baseURL) else { throw MovieProvdiderError.invalidBaseURL }
        let url =
            baseURL
            .appending(path: configuration.images.posterSizes.first ?? "")
            .appending(path: path)
        return url
    }

    func poster(path: String) async throws -> Data {
        let url = try await preparePosterURL(path: path)
        let request = try prepareRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)

        return data
    }
}
