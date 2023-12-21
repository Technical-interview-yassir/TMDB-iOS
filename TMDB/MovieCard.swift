//
//  MovieCard.swift
//  TMDB
//
//  Created by Maxime Bentin on 21.12.23.
//

import Foundation
import SwiftUI

struct MovieCard: View {
    let movie: Movie
    var body: some View {
        HStack {
            // AsyncImage(url: movie.poster)
            movie.image
            VStack {
                Text(movie.title)
                Text(movie.releaseDate.formatted())
            }
        }
    }
}

#Preview {
    MovieCard(
        movie: .init(
            id: 12,
            title: "Title",
            releaseDate: Date(),
            poster: "path of image"
        )
    )
}
