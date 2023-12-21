//
//  TMDBApp.swift
//  TMDB
//
//  Created by Maxime Bentin on 18.12.23.
//

import SwiftUI

struct TMDBApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView(movieStore: appDelegate.movieStore)
        }
    }
}

@main
struct AppLauncher {
    static func main() throws {
        if NSClassFromString("XCTestCase") == nil {
            TMDBApp.main()
        } else {
            TestApp.main()
        }
    }
}

struct TestApp: App {
    var body: some Scene {
        WindowGroup { Text("Running Unit Tests") }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    let movieProvider: HTTPMovieProvider
    @ObservedObject var movieStore: MovieStore

    override init() {
        let movieProvider = HTTPMovieProvider(secretManager: SecretManager())
        self.movieProvider = movieProvider
        self.movieStore = MovieStore(movieProvider: movieProvider)
        super.init()
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        Task {
            do {
                try await movieProvider.setup()
            } catch {
                print(error)
            }
        }
        return true
    }
}
