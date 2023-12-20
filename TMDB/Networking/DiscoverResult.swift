//
//  DiscoverResult.swift
//  TMDB
//
//  Created by Maxime Bentin on 20.12.23.
//

import Foundation

struct DiscoverMovie: Codable {
    let id: Int
    let title: String
    let relaseDate: Date
    let poster: URL
    enum CodingKeys: String, CodingKey {
        case id
        case title = "original_title"
        case relaseDate = "release_date"
        case poster = "poster_path"
    }
}

struct DiscoverResult: Codable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [DiscoverMovie]
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case results
    }
}
