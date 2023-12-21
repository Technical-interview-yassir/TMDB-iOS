//
//  Movie.swift
//  TMDB
//
//  Created by Maxime Bentin on 21.12.23.
//

import SwiftUI

struct Movie: Identifiable, Equatable {
    let id: Int
    let title: String
    let releaseDate: Date
    let poster: String
    var image: Image? = nil

    init(id: Int, title: String, releaseDate: Date, poster: String) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.poster = poster
    }

    init(discoverMovie: DiscoverMovie) {
        id = discoverMovie.id
        title = discoverMovie.title
        releaseDate = discoverMovie.relaseDate
        poster = discoverMovie.poster
    }
}
