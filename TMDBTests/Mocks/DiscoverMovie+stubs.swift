//
//  DiscoverMovie+stubs.swift
//  TMDBTests
//
//  Created by Maxime Bentin on 21.12.23.
//

import Foundation

@testable import TMDB

extension DiscoverMovie {
    static var stub: Self {
        Self(
            id: 12,
            title: "Mocked",
            relaseDate: Date(timeIntervalSince1970: 1_234_567),
            poster: "poster"
        )
    }
}
