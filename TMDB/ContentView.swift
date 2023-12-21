//
//  ContentView.swift
//  TMDB
//
//  Created by Maxime Bentin on 18.12.23.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @ObservedObject private var movieStore: MovieStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(movieStore.movies) { movie in
                    MovieCard(movie: movie)
                }
            }
            .navigationBarTitle("Trending", displayMode: .large)
        }
        .onAppear {
            Task {
                await movieStore.load()
            }
        }
    }

    init(movieStore: MovieStore) {
        self.movieStore = movieStore
    }
}

#Preview { ContentView(movieStore: PreviewMovieStore()) }

class PreviewMovieStore: MovieStore {
    // override var movies: [Movie] = []
    override func load() async {}
    init() {
        super.init(movieProvider: PreviewMovieProvider())
    }
}

struct PreviewMovieProvider: MovieProvider {
    func trendingMovies() async throws -> [DiscoverMovie] { [] }

    func poster(path: String) async throws -> Data { Data() }

    func setup() async throws {}
}
