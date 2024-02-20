import SwiftUI
import SwiftData
import ApollonShared
import ApollonEdit

struct DiagramDisplayView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var diagram: ApollonDiagram
    @State private var isExporting = false

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
                Text(diagram.title)
                    .font(.headline)
                    .bold()
                    .foregroundColor(Color(UIColor.systemBackground))
            }
            //            ToolbarItem(placement: .navigationBarTrailing) {
            //                Button {
            //                    viewModel.renderExport()
            //                    self.isExporting = true
            //                } label: {
            //                    Image(systemName: "square.and.arrow.up")
            //                        .foregroundColor(ApollonColor.toolBarItemColor)
            //                }
            //                .exportDiagram(viewModel: viewModel, isExporting: $isExporting)
            //            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(ApollonColor.toolBarBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
