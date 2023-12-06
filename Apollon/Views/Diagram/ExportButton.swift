import SwiftUI
import ApollonShared

struct ExportButton: View {
    @State var diagram: ApollonDiagram
    @State private var isExporting = false
    @State private var jsonFileDocument: JSONFile?
    var saveBeforeExport: () -> Void

    var body: some View {
        Button {
            saveBeforeExport()
            if let encodedDiagram = encodeDiagram(diagram) {
                jsonFileDocument = JSONFile(text: encodedDiagram)
                isExporting = true
            }
        } label: {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(ApollonColor.toolBarItemColor)
        }
        .confirmationDialog("Select an export format", isPresented: $isExporting, titleVisibility: .visible) {
            if let jsonFileDocument {
                ShareLink(item: jsonFileDocument,
                          preview: SharePreview(diagram.title, image: Image(uiImage: UIImage(named: "AppIcon") ?? UIImage()))) {
                    Text("JSON")
                }
            }
            ShareLink(item: "PDF",
                      preview: SharePreview(diagram.title, image: Image(uiImage: UIImage(named: "AppIcon") ?? UIImage()))) {
                Text("PDF (Not available)")
            }
            ShareLink(item: "PNG",
                      preview: SharePreview(diagram.title, image: Image(uiImage: UIImage(named: "AppIcon") ?? UIImage()))) {
                Text("PNG (Not available)")
            }
        }
    }

    private func encodeDiagram(_ diagram: ApollonDiagram) -> String? {
        do {
            if let modelData = diagram.model.data(using: .utf8) {
                let modelDecoded = try JSONDecoder().decode(UMLModel.self, from: modelData)
                let otherDiagram = Diagram(id: diagram.id,
                                           title: diagram.title,
                                           lastUpdate: diagram.lastUpdate,
                                           diagramType: diagram.diagramType,
                                           model: modelDecoded)
                let jsonData = try JSONEncoder().encode(otherDiagram)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    return jsonString
                }
            }
        } catch {
            print("Could not encode diagram: \(error)")
            return nil
        }
        return nil
    }
}
