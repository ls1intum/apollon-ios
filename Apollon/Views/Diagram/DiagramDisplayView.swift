import SwiftUI
import SwiftData
import ApollonShared
import ApollonEdit

struct DiagramDisplayView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Bindable var viewModel: DiagramViewModel
    var diagram: ApollonDiagram
    @State private var model = UMLModel()
    @State private var isExportingDiagram = false
    @State private var isRenamingDiagram = false
    @State private var newDiagramName = ""
    @State private var id = 0
    
    var body: some View {
        ZStack {
            ApollonEdit(umlModel: $model,
                        diagramType: diagram.diagramType,
                        fontSize: 14.0,
                        themeColor: Color.accentColor,
                        diagramOffset: CGPoint(x: 0, y: 0),
                        isGridBackground: true)
            .id(id)
            .onDisappear {
                diagram.model = model
                modelContext.insert(diagram)
                try? modelContext.save()
            }
            .onChange(of: diagram.model, initial: true) { oldValue, newValue in
                let modelEnoded = try? JSONEncoder().encode(diagram.model)
                let decoded = try? JSONDecoder().decode(UMLModel.self, from: modelEnoded ?? Data())
                model = decoded ?? .init() // Use empty if re-encoding doesn't work. We're fucked then anyway
                id += 1
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    diagram.lastUpdate = Date().ISO8601FormatWithFractionalSeconds()
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                    }
                }
                .foregroundColor(Color.accentColor)
            }
            ToolbarItem(placement: .principal) {
                Text(diagram.title)
                    .font(.headline)
                    .bold()
                    .foregroundColor(Color.primary)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        newDiagramName = diagram.title
                        isRenamingDiagram = true
                    } label: {
                        Label("Rename", systemImage: "pencil")
                    }
                    Button {
                        diagram.model = model
                        viewModel.renderExport()
                        self.isExportingDiagram = true
                    } label: {
                        Label("Export", systemImage: "square.and.arrow.up")
                    }
                    .accessibilityIdentifier("DiagramExportButton")
                    Button(role: .destructive) {
                        withAnimation {
                            dismiss()
                            modelContext.delete(diagram)
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .accessibilityIdentifier("DiagramMenuButton")
                .foregroundColor(Color.accentColor)
                .alert("Rename Diagram", isPresented: $isRenamingDiagram) {
                    TextField("Diagram Name", text: $newDiagramName)
                    Button("Cancel", role: .cancel) {}
                    Button("OK") {
                        diagram.title = newDiagramName
                    }
                } message: {
                    Text("Enter a new name for your diagram.")
                }
                .exportDiagram(viewModel: viewModel, isExporting: $isExportingDiagram)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
