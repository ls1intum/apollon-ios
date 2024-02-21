import Foundation
import SwiftUI
import ApollonShared
import ApollonView
import PDFKit

@MainActor
class DiagramViewModel: ObservableObject {
    /// The locally persisted diagram
    @Published var diagram: ApollonDiagram
    /// The exported JSON File
    @Published var jsonFile: JSONFile?
    /// The exported PNG Image
    @Published var pngImage: UIImage?
    /// The exported PDF File
    @Published var pdfFile: URL?

    init(diagram: ApollonDiagram) {
        self.diagram = diagram
    }

    /// Encodes the Diagram and returns a String
    func encodeDiagram() -> String? {
        do {
            let otherDiagram = Diagram(id: diagram.id,
                                       title: diagram.title,
                                       lastUpdate: diagram.lastUpdate,
                                       diagramType: diagram.diagramType,
                                       model: diagram.model)
            let jsonData = try JSONEncoder().encode(otherDiagram)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Could not encode diagram: \(error)")
            return nil
        }
        return nil
    }

    /// Renders the JSON, PNG and PDF files for export
    func renderExport() {
        let renderer = ImageRenderer(content: ApollonView(umlModel: diagram.model,
                                                          diagramType: diagram.diagramType,
                                                          fontSize: 14.0,
                                                          themeColor: Color.accentColor,
                                                          diagramOffset: CGPoint(x: 0, y: 0),
                                                          isGridBackground: false,
                                                          isPreview: true) {}
            .frame(width: diagram.model.size?.width ?? 1000, height: diagram.model.size?.height ?? 1000)
        )

        renderJSON()
        renderPNG(renderer: renderer)
        renderPDF(renderer: renderer)
    }

    private func renderJSON() {
        if let encodedDiagram = encodeDiagram() {
            jsonFile = JSONFile(text: encodedDiagram)
        }
    }

    private func renderPNG(renderer: ImageRenderer<some View>) {
        if let image = renderer.uiImage {
            pngImage = image
        }
    }

    private func renderPDF(renderer: ImageRenderer<some View>) {
        let url = URL.documentsDirectory.appending(path: "\(diagram.title).pdf")
        renderer.render { size, context in
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                return
            }
            pdf.beginPDFPage(nil)
            context(pdf)
            pdf.endPDFPage()
            pdf.closePDF()
        }
        pdfFile = url
    }
}

