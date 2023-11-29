import Foundation
import ApollonShared

@MainActor
class ApollonStandaloneViewModel: ObservableObject {
    @Published var diagram: ApollonDiagram
    @Published var umlModel: UMLModel?
    
    init(diagram: ApollonDiagram) {
        self.diagram = diagram
    }
    
    // Decode model from ApollonDiagram to UMLModel
    func decodeModel(){
        do {
            if let modelData = diagram.model.data(using: .utf8) {
                self.umlModel = try JSONDecoder().decode(UMLModel.self, from: modelData)
            }
        } catch {
            print("Could not decode UML string: \(error)")
        }
    }
    
    // Encode Model from UMLModel to ApollonDiagram
    func encodeModel() {
        do {
            let jsonData = try JSONEncoder().encode(self.umlModel)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                diagram.model = jsonString
            }
        } catch {
            print("Could not encode UML model: \(error)")
        }
    }
}

