import SwiftUI
import SwiftData

@main
struct ApollonApp: App {
    @State private var removeDiagrams: Bool = UserDefaults.standard.bool(forKey: "remove_diagrams")
    @State private var darkMode: Bool = UserDefaults.standard.bool(forKey: "dark_mode")

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
            DiagramListView()
                .onAppear {
                    NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: .main) { _ in
                        removeDiagrams = UserDefaults.standard.bool(forKey: "remove_diagrams")
                    }
                    if removeDiagrams {
                        sharedModelContainer.deleteAllData()
                        UserDefaults.standard.set(false, forKey: "remove_diagrams")
                    }
                }
                .onAppear {
                    NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: .main) { _ in
                        darkMode = UserDefaults.standard.bool(forKey: "dark_mode")
                    }
                }
                .onAppear {
                    let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
                    UserDefaults.standard.set(version, forKey: "version_number")
                    let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
                    UserDefaults.standard.set(build, forKey: "build_number")
                }
                .preferredColorScheme(darkMode ? .dark : .light)
        }
        .modelContainer(sharedModelContainer)
    }
}
