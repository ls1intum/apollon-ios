import XCTest
import SwiftData

@MainActor
class ApollonSnapshotUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        setupSnapshot(app)
        app.launchArguments += ["-Screenshots"]
        app.launch()
    }

    func testTakeScreenshots() {
        // Snapshot 1
        snapshot("01-DiagramListView")

        // Tap Diagram
        app.buttons["DiagramNavigationButton_1"].tap()

        // Sleep
        sleep(3)

        // Tap Add Element Button
        app.buttons["AddElementButton"].tap()

        // Snapshot 2
        snapshot("02-DiagramDisplayView")

        // Tap Add Element Button to close Menu
        app.buttons["AddElementButton"].forceTapElement()

        // Tap Diagram Menu
        app.buttons["DiagramMenuButton"].forceTapElement()

        // Tap Export Diagram Button
        app.buttons["DiagramExportButton"].forceTapElement()

        // Snapshot 3
        snapshot("03-DiagramExportButton")

        // Tap PNG Export
        app.buttons["DiagramExportPNG"].tap()

        // Sleep
        sleep(8)

        // Snapshot 4
        snapshot("04-DiagramShareButton")
    }
}


// https://stackoverflow.com/questions/33422681/xcode-ui-test-ui-testing-failure-failed-to-scroll-to-visible-by-ax-action
// Sends a tap event to a hittable/unhittable element
extension XCUIElement {
    func forceTapElement() {
        if self.isHittable {
            self.tap()
        }
        else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx:0.0, dy:0.0))
            coordinate.tap()
        }
    }
}
