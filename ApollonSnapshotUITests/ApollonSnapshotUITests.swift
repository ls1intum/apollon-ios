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

    func testTakePortraitScreenshots() {
        XCUIDevice.shared.orientation = .portrait
        // Snapshot 1
        snapshot("DiagramListViewPortrait")

        // Tap Diagram
        app.buttons["DiagramNavigationButton_1"].tap()

        // Sleep
        sleep(3)

        // Tap Add Element Button
        app.buttons["AddElementButton"].tap()

        // Snapshot 2
        snapshot("DiagramDisplayViewPortrait")

        // Tap Add Element Button to close Menu
        app.buttons["AddElementButton"].forceTapElement()

        // Tap Diagram Menu
        app.buttons["DiagramMenuButton"].forceTapElement()

        // Tap Export Diagram Button
        app.buttons["DiagramExportButton"].forceTapElement()

        // Snapshot 3
        snapshot("DiagramExportButtonPortrait")
    }

    func testTakeLandscapeScreenshots() {
        XCUIDevice.shared.orientation = .landscapeRight
        // Snapshot 1
        snapshot("DiagramListViewLandscape")

        // Tap Diagram
        app.buttons["DiagramNavigationButton_1"].tap()

        // Sleep
        sleep(3)

        // Tap Add Element Button
        app.buttons["AddElementButton"].tap()

        // Snapshot 2
        snapshot("DiagramDisplayViewLandscape")

        // Tap Add Element Button to close Menu
        app.buttons["AddElementButton"].forceTapElement()

        // Tap Diagram Menu
        app.buttons["DiagramMenuButton"].forceTapElement()

        // Tap Export Diagram Button
        app.buttons["DiagramExportButton"].forceTapElement()

        // Snapshot 3
        snapshot("DiagramExportButtonLandscape")
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
