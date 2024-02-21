import SwiftUI

extension View {
    func exportDiagram(viewModel: DiagramViewModel, isExporting: Binding<Bool>) -> some View {
        self.modifier(ExportDiagramModifier(viewModel: viewModel, isExporting: isExporting))
    }
}
