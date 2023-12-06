import SwiftUI
import SwiftData

@main
struct ApollonApp: App {
    // Stores the color scheme preference of the user in AppStorage
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    // The SwiftData model container for saving diagrams locally
    var sharedModelContainer: ModelContainer = {
        let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: false, allowsSave: true)
        do {
            return try ModelContainer(for: ApollonDiagram.self, configurations: modelConfiguration)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
        .modelContainer(sharedModelContainer)
    }
}
