import SwiftUI
import ApollonShared
import ApollonEdit

struct DiagramDisplayView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: ApollonViewModel

    init(diagram: ApollonDiagram) {
        self._viewModel = StateObject(wrappedValue: ApollonViewModel(diagram: diagram))
    }

    var body: some View {
        ZStack {
            if let model = viewModel.umlModel, let type = model.type {
                ApollonEdit(umlModel: Binding(
                    get: { viewModel.umlModel ?? UMLModel() },
                    set: { viewModel.umlModel = $0 }),
                            diagramType: type,
                            fontSize: 14.0,
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
                    viewModel.diagram.lastUpdate = Date().ISO8601Format()
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
                ExportButton(diagram: viewModel.diagram) {
                    viewModel.encodeModel()
                    viewModel.diagram.lastUpdate = Date().ISO8601Format()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(ApollonColor.toolBarBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
