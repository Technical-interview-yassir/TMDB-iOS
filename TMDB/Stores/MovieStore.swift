//
//  MovieStore.swift
//  TMDB
//
//  Created by Maxime Bentin on 21.12.23.
//

import Foundation
import SwiftUI

class MovieStore: ObservableObject {
    @MainActor @Published var movies: [Movie] = []
    private let movieProvider: MovieProvider

    init(movieProvider: MovieProvider) {
        self.movieProvider = movieProvider
    }

    @MainActor
    func load() async {
        do {
            let newMovies =
                try await self.movieProvider
                .trendingMovies()
                .map { Movie(discoverMovie: $0) }

            movies = try await self.downloadPosters(movies: newMovies)
        } catch {
            print("Failed: \(error)")
        }
    }

    private func downloadPosters(movies: [Movie]) async throws -> [Movie] {
        await withTaskGroup(
            of: (Int, Data?).self,
            returning: [Movie].self
        ) { [weak self] group in
            guard let self else { return [] }
            var moviesWithImages = Dictionary(uniqueKeysWithValues: movies.map { ($0.id, $0) })
            for movie in movies {
                group.addTask { await (movie.id, try? self.movieProvider.poster(path: movie.poster)) }
            }

            for await result in group {
                guard let data = result.1,
                    let uiImage = UIImage(data: data)
                else { continue }
                moviesWithImages[result.0]?.image = Image(uiImage: uiImage)
            }

            return Array(moviesWithImages.values)
        }
    }
}
