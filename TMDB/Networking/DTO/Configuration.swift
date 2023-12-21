//
//  Configuration.swift
//  TMDB
//
//  Created by Maxime Bentin on 21.12.23.
//

import Foundation

struct Configuration: Codable {
    struct Images: Codable {
        let baseURL: String
        let posterSizes: [String]

        enum CodingKeys: String, CodingKey {
            case baseURL = "secure_base_url"
            case posterSizes = "poster_sizes"
        }
    }
    let images: Images
}
