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
}
