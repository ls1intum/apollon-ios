import SwiftUI
import ApollonShared

struct DiagramListCellView: View {
    @State var diagram: ApollonDiagram

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("", text: bindingForDiagram(diagram))
                .padding(5)
                .background(.white)
                .foregroundColor(.black)
                .cornerRadius(3)
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(ApollonColor.toolBarBackground, lineWidth: 2)
                )

            Text("Last Update: \(formatDate(dateString: diagram.lastUpdate))")
                .font(.caption)
                .foregroundColor(.white)
                .lineLimit(1)

            HStack(spacing: 15) {
                Text(diagram.diagramType.rawValue.insertSpaceBeforeCapitalLetters())
                    .lineLimit(1)
                    .bold()
                    .foregroundColor(.white)
                    .padding(5)
                    .background(.green)
                    .cornerRadius(8)

                Spacer()

                ExportButton(diagram: diagram){}
            }
        }
        .padding(15)
        .background(Color.accentColor)
        .cornerRadius(3)
        .overlay(
            RoundedRectangle(cornerRadius: 3)
                .stroke(ApollonColor.toolBarBackground, lineWidth: 2)
        )
    }

    private func bindingForDiagram(_ diagram: ApollonDiagram) -> Binding<String> {
        Binding(
            get: { diagram.title },
            set: { newTitle in
                diagram.title = newTitle
            }
        )
    }

    private func formatDate(dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let isoDate = isoFormatter.date(from: dateString) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm:ss a"
            return dateFormatter.string(from: isoDate)
        }
        return ""
    }
}
