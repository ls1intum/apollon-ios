import Foundation
import SwiftData
import ApollonShared

/// The Diagram includes all the information of a UML Diagram which is saved in SwiftData
@Model public class ApollonDiagram {
    @Attribute(.unique) public var id: String
    @Attribute public var title: String
    @Attribute public var lastUpdate: String
    @Attribute public var diagramType: UMLDiagramType
    @Attribute public var model: String

    public init(id: String? = nil, title: String? = nil, lastUpdate: String? = nil, diagramType: UMLDiagramType, model: String? = nil) {
        self.id = id ?? UUID().uuidString.lowercased()
        self.title = title ?? diagramType.rawValue.insertSpaceBeforeCapitalLetters()
        self.lastUpdate = lastUpdate ?? Date().ISO8601FormatWithFractionalSeconds()
        self.diagramType = diagramType
        self.model = model ?? ""
    }

    static func encodeDiagram(_ diagram: ApollonDiagram) -> String? {
        do {
            if let modelData = diagram.model.data(using: .utf8) {
                let modelDecoded = try JSONDecoder().decode(UMLModel.self, from: modelData)
                let otherDiagram = Diagram(id: diagram.id,
                                           title: diagram.title,
                                           lastUpdate: diagram.lastUpdate,
                                           diagramType: diagram.diagramType,
                                           model: modelDecoded)
                let jsonData = try JSONEncoder().encode(otherDiagram)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    return jsonString
                }
            }
        } catch {
            print("Could not encode diagram: \(error)")
            return nil
        }
        return nil
    }
}
