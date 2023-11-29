import SwiftUI
import SwiftData

@main
struct apollon_ios_standaloneApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
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
