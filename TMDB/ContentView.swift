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

    @ViewBuilder
    func decorateMovieCard(id: Int) -> some View {
        if let movie = movieStore.movies[id] {
            NavigationLink(destination: MovieDetailsView(movieStore: movieStore, movie: movie)) {
                MovieCard(movie: movie)
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {
                List {
                    ForEach(movieStore.filteredMovies.keys, id: \.self) { id in
                        decorateMovieCard(id: id)
                            .task {
                                if movieStore.filteredMovies.keys.last == id {
                                    await movieStore.loadMoreMovies()
                                }
                            }
                    }
                }
                .searchable(text: $movieStore.searchedText)
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
    func movieDetails(id: Int) async throws -> MovieDetails {
        MovieDetails(id: 45, revenue: 50, budget: 30)
    }

    func trendingMovies(page: Int) async throws -> [DiscoverMovie] { [] }
    func poster(path: String, imageQuality: ImageQuality) async throws -> Data { Data() }
    func setup() async throws {}
}
