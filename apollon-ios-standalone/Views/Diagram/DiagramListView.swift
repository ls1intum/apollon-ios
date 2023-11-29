import SwiftUI
import SwiftData
import ApollonShared

struct DiagramListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var diagrams: [ApollonDiagram]
    @State private var isImporting = false
    @State private var shouldNavigate = false

    var body: some View {
        NavigationStack {
            VStack {
                if diagrams.isEmpty {
                    Spacer()

                    Text("No diagrams available...")
                        .foregroundColor(.primary)
                        .font(.title2)
                        .bold()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)

                    Text("Add a new diagram with \(Image(systemName: "plus")) or import a diagram with \(Image(systemName: "square.and.arrow.down")).")
                        .foregroundColor(ApollonColor.toolBarItemColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)

                    Spacer()
                } else {
                    List {
                        ForEach(diagrams) { diagram in
                            ZStack {
                                NavigationLink(destination: DiagramDisplay(diagram: diagram)) {
                                    EmptyView()
                                }
                                .opacity(0.0)
                                DiagramListCell(diagram: diagram)
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: deleteDiagram)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .listStyle(PlainListStyle())
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("tum_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                }
                ToolbarItem(placement: .principal) {
                    Text("Apollon")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(UMLDiagramType.allCases, id: \.self) { type in
                            if !UMLDiagramType.isDiagramTypeUnsupported(diagramType: type) {
                                Button(type.rawValue.insertSpaceBeforeCapitalLetters()) {
                                    addDiagram(diagramType: type)
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .foregroundColor(ApollonColor.toolBarItemColor)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isImporting.toggle()
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                    .foregroundColor(ApollonColor.toolBarItemColor)
                    .fileImporter(isPresented: $isImporting, allowedContentTypes: [.json], allowsMultipleSelection: false) { result in
                        do {
                            guard let selectedFile: URL = try result.get().first else { return }
                            let file = read(from: selectedFile)
                            switch file {
                            case .success(let stringValue):
                                let impDiagram = try JSONDecoder().decode(Diagram.self, from: Data(stringValue.utf8))
                                let jsonModelData = try JSONEncoder().encode(impDiagram.model)
                                if let jsonModelString = String(data: jsonModelData, encoding: .utf8), let type = impDiagram.diagramType {
                                    let apollonDiagram = ApollonDiagram(id: impDiagram.id, title: impDiagram.title, lastUpdate: impDiagram.lastUpdate, diagramType: type, model: jsonModelString)
                                    modelContext.insert(apollonDiagram)
                                } else {
                                    print("Error when importing")
                                }
                            case .failure(let error):
                                print("Error: \(error)")
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(ApollonColor.toolBarBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }

    private func addDiagram(diagramType: UMLDiagramType) {
        withAnimation {
            do {
                let newModelData = try JSONEncoder().encode(UMLModel(type: diagramType))
                if let jsonStringModel = String(data: newModelData, encoding: .utf8) {
                    let newDiagram = ApollonDiagram(diagramType: diagramType, model: jsonStringModel)
                    modelContext.insert(newDiagram)
                }
            } catch {
                print("Could not parse UML string: \(error)")
            }
        }
    }

    private func deleteDiagram(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(diagrams[index])
            }
        }
    }

    // Needed for importing
    private func read(from url: URL) -> Result<String,Error> {
        let accessing = url.startAccessingSecurityScopedResource()
        defer {
            if accessing {
                url.stopAccessingSecurityScopedResource()
            }
        }
        return Result { try String(contentsOf: url) }
    }
}
