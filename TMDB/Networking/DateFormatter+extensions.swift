//
//  DateFormatter+extensions.swift
//  TMDB
//
//  Created by Maxime Bentin on 20.12.23.
//

import Foundation

extension DateFormatter {
    static func customTMDB() -> DateFormatter {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        return dateFormater
    }
}
