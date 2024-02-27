import SwiftUI

struct ExportDiagramModifier: ViewModifier {
    @ObservedObject var viewModel: DiagramViewModel
    @Binding var isExporting: Bool

    func body(content: Content) -> some View {
        content
            .confirmationDialog("Select an export format", isPresented: $isExporting, titleVisibility: .visible) {
                if let jsonFile = viewModel.jsonFile {
                    ShareLink(item: jsonFile,
                              preview: SharePreview(viewModel.diagram.title, image: Image(uiImage: UIImage(named: "AppIcon") ?? UIImage()))) {
                        Text("JSON")
                    }
                }
                if let pngImage = viewModel.pngImage {
                    ShareLink(item: Image(uiImage: pngImage),
                              preview: SharePreview(viewModel.diagram.title, image: Image(uiImage: pngImage))) {
                        Text("PNG")
                    }
                }
                if let pdfFile = viewModel.pdfFile {
                    ShareLink(item: pdfFile) {
                        Text("PDF")
                    }
                }
            }
    }
}
