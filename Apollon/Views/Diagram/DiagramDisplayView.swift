import SwiftUI
import ApollonShared
import ApollonEdit

struct DiagramDisplayView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: ApollonViewModel
    @State private var isExporting = false
    @State private var jsonFileDocument: JSONFile?

    var body: some View {
        ZStack {
            if let model = viewModel.umlModel, let type = model.type {
                ApollonEdit(umlModel: Binding(
                    get: { viewModel.umlModel ?? UMLModel() },
                    set: { viewModel.umlModel = $0 }),
                            diagramType: type,
                            fontSize: 14.0,
                            themeColor: Color.accentColor,
                            diagramOffset: CGPoint(x: 0, y: 0),
                            isGridBackground: true)
            }
        }
        .onAppear() {
            viewModel.decodeModel()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    viewModel.encodeModel()
                    viewModel.diagram.lastUpdate = Date().ISO8601FormatWithFractionalSeconds()
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                    }
                }
                .foregroundColor(ApollonColor.toolBarItemColor)
            }
            ToolbarItem(placement: .principal) {
                Text(viewModel.diagram.title)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.encodeModel()
                    viewModel.diagram.lastUpdate = Date().ISO8601FormatWithFractionalSeconds()
                    if let encodedDiagram = ApollonDiagram.encodeDiagram(viewModel.diagram) {
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
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(ApollonColor.toolBarBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
