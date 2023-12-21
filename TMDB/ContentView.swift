//
//  ContentView.swift
//  TMDB
//
//  Created by Maxime Bentin on 18.12.23.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @ObservedObject var movieStore: MovieStore
    var body: some View {
        Text("TMDB")
        List {
            ForEach(movieStore.movies) { movie in
                Text(movie.title)
            }
        }
        .onAppear {
            movieStore.load()
        }
    }
    
    init() {
        let provider = HTTPMovieProvider(secretManager: SecretManager())
        movieStore = MovieStore(movieProvider: provider)
    }
}

#Preview { ContentView() }
