import SwiftUI
import ApollonShared

struct DiagramListCellView: View {
    @State var diagram: ApollonDiagram
    @ObservedObject var timeTicker: GlobalTimeTicker
    @State private var draftTitle: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("", text: $draftTitle)
                .padding(5)
                .background(.white)
                .foregroundColor(.black)
                .cornerRadius(3)
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(ApollonColor.toolBarBackground, lineWidth: 2)
                )

            Text("\(dateLabel): \(timeAgoFormat(dateString: relevantDate, currentTime: Date()))")
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
        .onAppear {
                self.draftTitle = diagram.title
        }
        .onSubmit {
            self.commitChangesIfNeeded()
        }
        .onChange(of: timeTicker.tick) { _, _ in
            
        }
    }
    
    private func commitChangesIfNeeded() {
        guard draftTitle != diagram.title else { return }
        diagram.title = draftTitle
        diagram.lastUpdate = Date().ISO8601FormatWithFractionalSeconds()
    }
    
    private var dateLabel: String {
        diagram.firstCreated == diagram.lastUpdate ? "Created" : "Last Updated"
    }

    private var relevantDate: String {
        diagram.firstCreated == diagram.lastUpdate ? diagram.firstCreated : diagram.lastUpdate
    }

    private func timeAgoFormat(dateString: String, currentTime: Date) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = isoFormatter.date(from: dateString) else { return "Date format error" }

        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: now)

        if let year = components.year, year > 0 {
            return "\(year) yr" + (year > 1 ? "s" : "") + " ago"
        } else if let month = components.month, month > 0 {
            return "\(month) mo" + (month > 1 ? "s" : "") + " ago"
        } else if let day = components.day, day > 0 {
            return "\(day) d" + (day > 1 ? "s" : "") + " ago"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour) hr" + (hour > 1 ? "s" : "") + " ago"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute) min" + (minute > 1 ? "s" : "") + " ago"
        } else if let second = components.second, second > 0 {
            return "Just now"
        } else {
            return "Just now"
        }
    }

//    private func bindingForDiagram(_ diagram: ApollonDiagram) -> Binding<String> {
//        Binding(
//            get: { diagram.title },
//            set: { newTitle in
//                diagram.title = newTitle
//            }
//        )
//    }
//
//    private func formatDate(dateString: String) -> String {
//        let isoFormatter = ISO8601DateFormatter()
//        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//        if let isoDate = isoFormatter.date(from: dateString) {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm:ss a"
//            return dateFormatter.string(from: isoDate)
//        }
//        return ""
//    }
}
