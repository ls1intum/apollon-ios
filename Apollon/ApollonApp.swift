import SwiftUI
import SwiftData

@main
struct ApollonApp: App {
    @State private var darkMode: Bool = UserDefaults.standard.bool(forKey: "dark_mode")

    var body: some Scene {
        WindowGroup {
            DiagramListView()
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
        .modelContainer(for: ApollonDiagram.self, isAutosaveEnabled: true)
    }
}
