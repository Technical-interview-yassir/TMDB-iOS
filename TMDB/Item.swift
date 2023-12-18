//
//  Item.swift
//  TMDB
//
//  Created by Maxime Bentin on 18.12.23.
//

import Foundation
import SwiftData

@Model final class Item {
    var timestamp: Date

    init(timestamp: Date) { self.timestamp = timestamp }
}
