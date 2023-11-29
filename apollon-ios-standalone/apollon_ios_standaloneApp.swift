//
//  apollon_ios_standaloneApp.swift
//  apollon-ios-standalone
//
//  Created by Alexander Görtzen on 29.11.23.
//

import SwiftUI
import SwiftData

@main
struct apollon_ios_standaloneApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
