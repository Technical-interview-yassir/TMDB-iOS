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
            ZStack(alignment: .center) {
                List {
                    ForEach(movieStore.movies) { movie in
                        MovieCard(movie: movie)
                    }
                }
                .refreshable {
                    Task {
                        await movieStore.load()
                    }
                }
                
                if movieStore.loading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(5)
                }
            }
            .navigationBarTitle("Trending", displayMode: .large)
        }
        .task {
            await movieStore.load()
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
