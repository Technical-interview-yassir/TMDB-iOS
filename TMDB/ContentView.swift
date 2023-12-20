//
//  ContentView.swift
//  TMDB
//
//  Created by Maxime Bentin on 18.12.23.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    let provider = HTTPMovieProvider(secretManager: SecretManager())
    var body: some View {
        Text("TMDB")
            .onAppear {
                Task {
                    do {
                        let res = try await provider.trendingMovies()
                        print(res)
                    } catch { print(error) }
                }
            }
    }
}

#Preview { ContentView() }
