//
//  Movie+stub.swift
//  TMDBTests
//
//  Created by Maxime Bentin on 22.12.23.
//

import Foundation

@testable import TMDB

extension Movie {
    static var stub: Self {
        Self(
            id: 45,
            title: "Mocked",
            releaseDate: Date(timeIntervalSince1970: 987_654_321),
            poster: "postter"
        )
    }
}
