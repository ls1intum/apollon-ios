import SwiftUI
import SwiftData
import ApollonShared

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
        .modelContainer(checkIfMockingDiagrams())
    }

    func checkIfMockingDiagrams() -> ModelContainer {
        if CommandLine.arguments.contains("-Screenshots") {
            let mockConfig = ModelConfiguration(isStoredInMemoryOnly: true)
            let mockContainer = try! ModelContainer(for: ApollonDiagram.self, configurations: mockConfig)
            ModelContext(mockContainer).insert(ApollonDiagram(title: "Spaceship Class", diagramType: .classDiagram, model: UMLModel(type: .classDiagram)))
            ModelContext(mockContainer).insert(ApollonDiagram(title: "Student Cases", diagramType: .useCaseDiagram, model: UMLModel(type: .useCaseDiagram)))
            ModelContext(mockContainer).insert(ApollonDiagram(title: "System Architecture", diagramType: .componentDiagram, model: UMLModel(type: .componentDiagram)))
            return mockContainer
        } else {
            let container = try! ModelContainer(for: ApollonDiagram.self)
            return container
        }
    }
}
