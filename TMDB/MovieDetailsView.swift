//
//  MovieDetails.swift
//  TMDB
//
//  Created by Maxime Bentin on 21.12.23.
//

import SwiftUI

struct MovieDetailsView: View {
    @ObservedObject var movieStore: MovieStore
    let movie: Movie

    var body: some View {
        VStack {
            movie.image?
                .resizable()
                .scaledToFit()

            Text(movie.title)
            if let profit = movie.profit {
                if profit > 0 {
                    Text("According to the revenue and budget, the movie made a profit of \(profit)$")
                } else {
                    Text("According to the revenue and budget, the movie made a loss of \(profit)$")
                }
            }
            Spacer()
        }
        .task {
            await movieStore.addDetailsTo(id: movie.id)
        }
    }
}

#Preview {
    MovieDetailsView(
        movieStore: PreviewMovieStore(),
        movie: .init(
            id: 12,
            title: "title",
            releaseDate: Date(),
            poster: "poster"
        )
    )
}
