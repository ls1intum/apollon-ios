import Foundation
import SwiftData
import ApollonShared

/// The Diagram includes all the information of a UML Diagram which is saved in SwiftData
@Model
public class ApollonDiagram {
    @Attribute(.unique) public var id: String
    @Attribute public var title: String
    @Attribute public var lastUpdate: String
    @Attribute public var diagramType: UMLDiagramType
    @Attribute public var model: UMLModel

    public init(id: String? = nil, title: String? = nil, lastUpdate: String? = nil, diagramType: UMLDiagramType, model: UMLModel? = nil) {
        self.id = id ?? UUID().uuidString.lowercased()
        self.title = title ?? diagramType.rawValue.insertSpaceBeforeCapitalLetters()
        self.lastUpdate = lastUpdate ?? Date().ISO8601FormatWithFractionalSeconds()
        self.diagramType = diagramType
        self.model = model ?? UMLModel(type: diagramType)
    }
    
    /// Returns a relative date description for the model's last update date
    /// If the last update date is within the last hour a relative string is returned, e.g. 11 minutes ago
    /// Otherwise, the date and time is displayed, e.g. Today, 11:45 or 13.02.24, 11:45
    public var relativeDateDescription: String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = isoFormatter.date(from: lastUpdate) else {
            return ""
        }
        
        if let diff = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour, diff < 1 {
            return RelativeDateTimeFormatter.namedAndSpelledOut.localizedString(for: date, relativeTo: Date())
        }
        
        return DateFormatter.dateAndTime.string(from: date)
    }
}
