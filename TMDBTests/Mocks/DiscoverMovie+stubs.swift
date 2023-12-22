//
//  DiscoverMovie+stubs.swift
//  TMDBTests
//
//  Created by Maxime Bentin on 21.12.23.
//

import Foundation

@testable import TMDB

extension DiscoverMovie {
    static var stub: Self = stub()

    static func stub(
        id: Int = 12,
        title: String = "Mocked",
        releaseDate: Date = Date(timeIntervalSince1970: 1_234_567),
        poster: String = "poster"
    ) -> Self {
        Self(
            id: id,
            title: title,
            releaseDate: releaseDate,
            poster: poster
        )
    }
}
