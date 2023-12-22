//
//  Movie+stub.swift
//  TMDBTests
//
//  Created by Maxime Bentin on 22.12.23.
//

import Foundation

@testable import TMDB

extension Movie {
    static var stub: Self = stub()

    static func stub(
        id: Int = 45,
        title: String = "Mocked",
        releaseDate: Date = Date(timeIntervalSince1970: 987_654_321),
        poster: String = "postter"
    ) -> Self {
        Self(
            id: id,
            title: title,
            releaseDate: releaseDate,
            poster: poster
        )
    }
}
