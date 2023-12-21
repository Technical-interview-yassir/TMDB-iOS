//
//  MovieStore.swift
//  TMDB
//
//  Created by Maxime Bentin on 21.12.23.
//

import Foundation
import SwiftUI

struct Movie: Identifiable {
    let id: Int
    let title: String
    let releaseDate: Date
    let poster: URL
    
    init(discoverMovie: DiscoverMovie) {
        id = discoverMovie.id
        title = discoverMovie.title
        releaseDate = discoverMovie.relaseDate
        poster = discoverMovie.poster
    }
}

class MovieStore: ObservableObject {
    @MainActor @Published var movies: [Movie] = []
    
    let movieProvider: MovieProvider
    
    init(movieProvider: MovieProvider) {
        self.movieProvider = movieProvider
    }
    
    @MainActor
    func load() {
        Task {
            do {
                movies = try await movieProvider
                    .trendingMovies()
                    .map { Movie(discoverMovie: $0) }
            } catch {
                print("Failed: \(error)")
            }
        }
    }
}
