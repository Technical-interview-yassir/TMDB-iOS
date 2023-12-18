//
//  TMDBApp.swift
//  TMDB
//
//  Created by Maxime Bentin on 18.12.23.
//

import SwiftData
import SwiftUI

@main struct TMDBApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Item.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do { return try ModelContainer(for: schema, configurations: [modelConfiguration]) } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene { WindowGroup { ContentView() }.modelContainer(sharedModelContainer) }
}
