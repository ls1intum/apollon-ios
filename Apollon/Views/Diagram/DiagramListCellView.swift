import SwiftUI
import SwiftData
import ApollonShared
import ApollonView

struct DiagramListCellView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: DiagramViewModel
    @State var diagram: ApollonDiagram
    @State private var isExporting = false
    @State private var isRenaming = false
    @State private var newRenamingName = ""
    
    init(diagram: ApollonDiagram) {
        self.diagram = diagram
        self._viewModel = ObservedObject(wrappedValue: DiagramViewModel(diagram: diagram))
    }
    
    var body: some View {
        VStack {
            ZStack {
                ApollonView(umlModel: diagram.model,
                            diagramType: diagram.diagramType,
                            fontSize: 14.0,
                            themeColor: Color.accentColor,
                            diagramOffset: CGPoint(x: 0, y: 0),
                            isGridBackground: false,
                            isPreview: true) {}
                    .id(diagram.model)
                    .frame(height: 175, alignment: .center)
            }
            
            Spacer()
            
            NavigationLink(destination: DiagramDisplayView(viewModel: viewModel, diagram: diagram)) {
                VStack(alignment: .leading) {
                    Text(diagram.title)
                        .font(.body)
                        .bold()
                        .foregroundColor(Color(UIColor.systemBackground))
                        .lineLimit(1)
                    
                    Text(diagram.diagramType.rawValue.insertSpaceBeforeCapitalLetters())
                        .font(.subheadline)
                        .foregroundColor(Color.accentColor)
                        .lineLimit(1)
                    
                    Text(formatDate(dateString: diagram.lastUpdate))
                        .font(.footnote)
                        .foregroundColor(ApollonColor.toolBarItemColor)
                        .lineLimit(1)
                }
                .padding(.leading, 10)
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(ApollonColor.toolBarBackground)
            }
            .accessibilityIdentifier("DiagramNavigationButton_\(diagram.id)")
        }
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(ApollonColor.toolBarBackground, lineWidth: 1.5)
        )
        .shadow(color: ApollonColor.toolBarBackground.opacity(0.75), radius: 2, x: 0, y: 1)
        .contextMenu {
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
            Button(role: .destructive) {
                withAnimation {
                    modelContext.delete(diagram)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .alert("Rename Diagram", isPresented: $isRenaming) {
            TextField("Diagram Name", text: $newRenamingName)
                .foregroundColor(Color(UIColor.systemBackground))
            Button("Cancel", role: .cancel) {}
            Button("OK") {
                diagram.title = newRenamingName
            }
        } message: {
            Text("Enter a new name for your diagram.")
        }
        .exportDiagram(viewModel: viewModel, isExporting: $isExporting)
    }
    
    private func formatDate(dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let isoDate = isoFormatter.date(from: dateString) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
            return dateFormatter.string(from: isoDate)
        }
        return ""
    }
}
