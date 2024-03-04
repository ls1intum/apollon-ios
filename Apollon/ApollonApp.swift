import SwiftUI
import SwiftData
import ApollonShared

@main
struct ApollonApp: App {
    @State var snapshotColorScheme: ColorScheme? = nil

    var body: some Scene {
        WindowGroup {
            DiagramListView()
                .onAppear {
                    setupApp()
                }
                .preferredColorScheme(snapshotColorScheme)
        }
        .modelContainer(checkIfMockingDiagrams())
    }

    private func setupApp() {
        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        UserDefaults.standard.set(version, forKey: "version_number")
        let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        UserDefaults.standard.set(build, forKey: "build_number")
#if DEBUG
        // Sets the ColorScheme based on the "-ColorScheme" flag set during screenshot tests
        // https://stackoverflow.com/questions/75745926/force-app-appearance-in-xcode-ui-tests-to-be-light-or-dark
        if let flagIndex = ProcessInfo.processInfo.arguments.firstIndex(where: { $0 == "-ColorScheme" }) {
            let colorScheme = ProcessInfo.processInfo.arguments[flagIndex + 1]
            if colorScheme == "Light" {
                self.snapshotColorScheme = ColorScheme.light
            } else if colorScheme == "Dark" {
                self.snapshotColorScheme = ColorScheme.dark
            }
        }
#endif
    }

    private func checkIfMockingDiagrams() -> ModelContainer {
        if CommandLine.arguments.contains("-Screenshots") {
#if DEBUG
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
#endif
        } else {
            let container = try! ModelContainer(for: ApollonDiagram.self)
            return container
        }
    }
}
