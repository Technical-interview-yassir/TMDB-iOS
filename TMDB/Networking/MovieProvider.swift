//
//  MovieProvider.swift
//  TMDB
//
//  Created by Maxime Bentin on 20.12.23.
//

import Foundation
import SwiftUI

protocol MovieProvider {
    func trendingMovies(page: Int) async throws -> [DiscoverMovie]
    func poster(path: String, imageQuality: ImageQuality) async throws -> Data
    func movieDetails(id: Int) async throws -> MovieDetails
}

enum MovieProviderError: Error {
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
            throw MovieProviderError.plistNotFound
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

    func prepareDiscovergMoviesURL(page: Int) -> URL? {
        guard var baseURL else { return nil }
        baseURL.append(path: "discover/movie")
        baseURL = baseURL.appending(queryItems: [
            .init(name: "page", value: "\(page)")
        ])

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

    func trendingMovies(page: Int) async throws -> [DiscoverMovie] {
        guard let url = prepareDiscovergMoviesURL(page: page) else { return [] }
        let request = try prepareRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try decoder.decode(DiscoverResult.self, from: data)

        return result.results
    }

    func prepareFetchConfigurationURL() throws -> URL {
        guard var baseURL else { throw MovieProviderError.invalidBaseURL }
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

    func preparePosterURL(path: String, imageQuality: ImageQuality) async throws -> URL {
        guard let configuration else { throw MovieProviderError.configurationFetchFailed }
        guard let baseURL = URL(string: configuration.images.baseURL) else { throw MovieProviderError.invalidBaseURL }

        let posterSize =
            switch imageQuality {
            case .low:
                configuration.images.posterSizes.first
            case .high:
                configuration.images.posterSizes.last
            }

        let url =
            baseURL
            .appending(path: posterSize ?? "")
            .appending(path: path)

        return url
    }

    func poster(path: String, imageQuality: ImageQuality) async throws -> Data {
        let url = try await preparePosterURL(path: path, imageQuality: imageQuality)
        let request = try prepareRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)

        return data
    }

    func prepareMovieDetailsURL(id: Int) throws -> URL {
        guard var baseURL else { throw MovieProviderError.invalidBaseURL }
        baseURL.append(path: "movie/\(id)")
        return baseURL
    }

    func movieDetails(id: Int) async throws -> MovieDetails {
        let url = try prepareMovieDetailsURL(id: id)
        let request = try prepareRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try decoder.decode(MovieDetails.self, from: data)

        return result
    }
}
