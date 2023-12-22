//
//  MovieStore.swift
//  TMDB
//
//  Created by Maxime Bentin on 21.12.23.
//

import Foundation
import OrderedCollections
import SwiftUI

class MovieStore: ObservableObject {
    @MainActor @Published var movies: OrderedDictionary<Int, Movie> = [:]
    @MainActor var filteredMovies: OrderedDictionary<Int, Movie> {
        if searchedText.isEmpty {
            return movies
        } else {
            return movies.filter { $0.value.title.contains(searchedText) }
        }
    }
    @MainActor @Published var loading: Bool = false
    @MainActor @Published var searchedText: String = ""

    private let movieProvider: MovieProvider
    private var pageLoaded: Int = 1

    init(movieProvider: MovieProvider) {
        self.movieProvider = movieProvider
    }

    @MainActor
    func load() async {
        loading = true
        do {
            let newMovies =
                try await self.movieProvider
                .trendingMovies(page: pageLoaded)
                .map { Movie(discoverMovie: $0) }

            let moviesWithPoster = try await self.downloadPosters(movies: newMovies)
            movies = movies.merging(
                moviesWithPoster,
                uniquingKeysWith: { movie1, _ in
                    movie1
                }
            )
        } catch {
            print("Failed: \(error)")
        }
        loading = false
    }

    func loadMoreMovies() async {
        pageLoaded += 1
        await load()
    }

    @MainActor
    func addDetailsTo(id: Int) async {
        guard let movie = movies[id] else { return }
        guard movie.profit == nil else { return }

        loading = true
        do {
            async let imageData = self.movieProvider.poster(
                path: movie.poster,
                imageQuality: .high
            )
            async let details = try movieProvider.movieDetails(id: id)

            let image: Image? =
                if let uiImage = UIImage(data: try await imageData) {
                    Image(uiImage: uiImage)
                } else {
                    nil
                }

            movies[id]?.addDetails(details: try await details, image: image)
        } catch {
            print("Failed: \(error)")
        }
        loading = false
    }

    private func downloadPosters(movies: [Movie]) async throws -> OrderedDictionary<Int, Movie> {
        await withTaskGroup(
            of: (Int, Data?).self,
            returning: OrderedDictionary<Int, Movie>.self
        ) { [weak self] group in
            guard let self else { return [:] }
            var moviesWithImages = OrderedDictionary(uniqueKeysWithValues: movies.map { ($0.id, $0) })
            for movie in movies {
                group.addTask {
                    await (
                        movie.id,
                        try? self.movieProvider.poster(
                            path: movie.poster,
                            imageQuality: .low
                        )
                    )
                }
            }

            for await result in group {
                guard let data = result.1,
                    let uiImage = UIImage(data: data)
                else { continue }
                moviesWithImages[result.0]?.image = Image(uiImage: uiImage)
            }

            return moviesWithImages
        }
    }
}
