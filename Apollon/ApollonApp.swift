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
                    setupApp()
                }
                .preferredColorScheme(darkMode ? .dark : .light)
        }
        .modelContainer(checkIfMockingDiagrams())
    }

    private func setupApp() {
        NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: .main) { _ in
            darkMode = UserDefaults.standard.bool(forKey: "dark_mode")
        }
        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        UserDefaults.standard.set(version, forKey: "version_number")
        let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        UserDefaults.standard.set(build, forKey: "build_number")
    }

    private func checkIfMockingDiagrams() -> ModelContainer {
        if CommandLine.arguments.contains("-Screenshots") {
            let mockConfig = ModelConfiguration(isStoredInMemoryOnly: true)
            let mockContainer = try! ModelContainer(for: ApollonDiagram.self, configurations: mockConfig)
            do {
                let classDiagram = try JSONDecoder().decode(Diagram.self, from: Data(MockDiagrams.classDiagramMockJSON.utf8))
                ModelContext(mockContainer).insert(ApollonDiagram(id: "1", title: "Animals", lastUpdate: classDiagram.lastUpdate, diagramType: .classDiagram, model: classDiagram.model))
                let useCaseDiagram = try JSONDecoder().decode(Diagram.self, from: Data(MockDiagrams.useCaseDiagramMockJSON.utf8))
                ModelContext(mockContainer).insert(ApollonDiagram(id: "2", title: "Students", lastUpdate: useCaseDiagram.lastUpdate, diagramType: .useCaseDiagram, model: useCaseDiagram.model))
                let componentDiagram = try JSONDecoder().decode(Diagram.self, from: Data(MockDiagrams.componentDiagramMockJSON.utf8))
                ModelContext(mockContainer).insert(ApollonDiagram(id: "3", title: "System Architecture", lastUpdate: componentDiagram.lastUpdate, diagramType: .componentDiagram, model: componentDiagram.model))
            } catch {
                print("Error decoding JSON: \(error)")
            }
            return mockContainer
        } else {
            let container = try! ModelContainer(for: ApollonDiagram.self)
            return container
        }
    }
}
