import SwiftUI
import ApollonShared
import ApollonView

struct DiagramListCellView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var viewModel: ApollonViewModel
    @State private var jsonFileDocument: JSONFile?
    @State private var isExporting = false
    @State private var isRenaming = false
    @State private var newRenamingName = ""

    var body: some View {
        VStack(alignment: .leading) {
            if let model = viewModel.umlModel, let type = model.type {
                ApollonView(umlModel: model,
                            diagramType: type,
                            fontSize: 14.0,
                            themeColor: Color.accentColor,
                            diagramOffset: CGPoint(x: 0, y: 0),
                            isGridBackground: false) {}
                    .frame(width: 150, height: 150)
            }

            Spacer()

            HStack {
                NavigationLink(destination: DiagramDisplayView(viewModel: viewModel)) {
                    VStack(alignment: .leading) {
                        Text(viewModel.diagram.title)
                            .font(.body)
                            .bold()
                            .foregroundColor(Color(UIColor.systemBackground))
                            .lineLimit(1)

                        Text(viewModel.diagram.diagramType.rawValue.insertSpaceBeforeCapitalLetters())
                            .font(.subheadline)
                            .foregroundColor(Color.accentColor)
                            .lineLimit(1)

                        Text(formatDate(dateString: viewModel.diagram.lastUpdate))
                            .font(.footnote)
                            .foregroundColor(ApollonColor.toolBarItemColor)
                            .lineLimit(1)
                    }
                }

                Spacer()

                Menu {
                    Button {
                        newRenamingName = viewModel.diagram.title
                        isRenaming = true
                    } label: {
                        Label("Rename", systemImage: "pencil")
                    }
                    Button {
                        if let encodedDiagram = ApollonDiagram.encodeDiagram(viewModel.diagram) {
                            jsonFileDocument = JSONFile(text: encodedDiagram)
                            isExporting = true
                        }
                    } label: {
                        Label("Export", systemImage: "square.and.arrow.up")
                    }
                    Button(role: .destructive) {
                        withAnimation {
                            modelContext.delete(viewModel.diagram)
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(ApollonColor.toolBarItemColor)
                }
                .confirmationDialog("Select an export format", isPresented: $isExporting, titleVisibility: .visible) {
                    if let jsonFileDocument {
                        ShareLink(item: jsonFileDocument,
                                  preview: SharePreview(viewModel.diagram.title, image: Image(uiImage: UIImage(named: "AppIcon") ?? UIImage()))) {
                            Text("JSON")
                        }
                    }
                    ShareLink(item: "PDF",
                              preview: SharePreview(viewModel.diagram.title, image: Image(uiImage: UIImage(named: "AppIcon") ?? UIImage()))) {
                        Text("PDF (Not available)")
                    }
                    ShareLink(item: "PNG",
                              preview: SharePreview(viewModel.diagram.title, image: Image(uiImage: UIImage(named: "AppIcon") ?? UIImage()))) {
                        Text("PNG (Not available)")
                    }
                }
                .alert("Rename Diagram", isPresented: $isRenaming) {
                    TextField("Diagram Name", text: $newRenamingName)
                    Button("Cancel", role: .cancel) {}
                    Button("OK") {
                        viewModel.diagram.title = newRenamingName
                    }
                } message: {
                    Text("Enter a new name for your diagram.")
                }
            }
            .padding(5)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(ApollonColor.toolBarBackground)
        }
        .cornerRadius(3)
        .overlay(
            RoundedRectangle(cornerRadius: 3)
                .stroke(ApollonColor.toolBarBackground, lineWidth: 1)
        )
        .onAppear() {
            viewModel.decodeModel()
        }
    }

    private func formatDate(dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let isoDate = isoFormatter.date(from: dateString) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy, H:mm"
            return dateFormatter.string(from: isoDate)
        }
        return ""
    }
}
