import SwiftUI
import SwiftData
import ApollonShared
import ApollonEdit

struct DiagramDisplayView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: DiagramViewModel
    @State var diagram: ApollonDiagram
    @State private var isExporting = false
    @State private var isRenaming = false
    @State private var newRenamingName = ""

    var body: some View {
        ZStack {
            ApollonEdit(umlModel: $diagram.model,
                        diagramType: diagram.diagramType,
                        fontSize: 14.0,
                        themeColor: Color.accentColor,
                        diagramOffset: CGPoint(x: 0, y: 0),
                        isGridBackground: true)
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
                        newRenamingName = diagram.title
                        isRenaming = true
                    } label: {
                        Label("Rename", systemImage: "pencil")
                    }
                    Button {
                        viewModel.renderExport()
                        self.isExporting = true
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
                .alert("Rename Diagram", isPresented: $isRenaming) {
                    TextField("Diagram Name", text: $newRenamingName)
                        .foregroundColor(ApollonColor.darkGray)
                    Button("Cancel", role: .cancel) {}
                    Button("OK") {
                        diagram.title = newRenamingName
                    }
                } message: {
                    Text("Enter a new name for your diagram.")
                }
                .exportDiagram(viewModel: viewModel, isExporting: $isExporting)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(ApollonColor.lightGray, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
