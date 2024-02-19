import SwiftUI
import ApollonShared
import ApollonView

struct DiagramListCellView: View {
    @State var diagram: ApollonDiagram

    var body: some View {
        VStack(alignment: .leading) {
            ApollonView(umlModel: decodeModel(apollonDiagram: diagram),
                        diagramType: decodeModel(apollonDiagram: diagram).type!,
                        fontSize: 14.0,
                        themeColor: Color.accentColor,
                        diagramOffset: CGPoint(x: 0, y: 0),
                        isGridBackground: false) {}
                .frame(width: 150, height: 150)

            Spacer()

            NavigationLink(destination: DiagramDisplayView(diagram: diagram)) {
                VStack(alignment: .leading) {
                    Text(diagram.title)
                        .font(.body)
                        .bold()
                        .foregroundColor(Color(UIColor.systemBackground))

                    Text(diagram.diagramType.rawValue.insertSpaceBeforeCapitalLetters())
                        .font(.subheadline)
                        .foregroundColor(Color.accentColor)

                    Text(formatDate(dateString: diagram.lastUpdate))
                        .font(.footnote)
                        .foregroundColor(Color.apollonToolbarItem)
                }
                .padding(5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.apollonToolbar)
            }
        }
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
            dateFormatter.dateFormat = "d.MM.yyyy, H:mm"
            return dateFormatter.string(from: isoDate)
        }
        return ""
    }

    private func decodeModel(apollonDiagram: ApollonDiagram) -> UMLModel {
        var umlModel: UMLModel = UMLModel()
        do {
            if let modelData = apollonDiagram.model.data(using: .utf8) {
                umlModel = try JSONDecoder().decode(UMLModel.self, from: modelData)
            }
        } catch {
            print("Could not decode UML string: \(error)")
        }
        return umlModel
    }
}
