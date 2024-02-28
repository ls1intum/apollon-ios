import XCTest
import SwiftData

@MainActor
class ApollonSnapshotUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        setupSnapshot(app)
        app.launchArguments += ["-Screenshots"]
    }

    func testTakeDarkModePortraitScreenshots() {
        app.launchArguments += ["-dark_mode", "YES"]
        XCUIDevice.shared.orientation = .portrait
        app.launch()

        // Tap Diagram
        app.buttons["DiagramNavigationButton_1"].tap()

        // Sleep
        sleep(2)

        // Snapshot
        snapshot("DiagramDisplayViewPortraitDarkMode")
    }

    func testTakeDarkModeLandscapeScreenshots() {
        app.launchArguments += ["-dark_mode", "YES"]
        XCUIDevice.shared.orientation = .landscapeRight
        app.launch()

        // Tap Diagram
        app.buttons["DiagramNavigationButton_1"].tap()

        // Sleep
        sleep(2)

        // Snapshot
        snapshot("DiagramDisplayViewLandscapeDarkMode")
    }

    func testTakePortraitScreenshots() {
        app.launchArguments += ["-dark_mode", "NO"]
        XCUIDevice.shared.orientation = .portrait
        app.launch()

        // Snapshot
        snapshot("DiagramListViewPortrait")

        // Tap diagram
        app.buttons["DiagramNavigationButton_1"].tap()

        // Sleep
        sleep(2)

        // Tap random location on screen to select element
        app.images["UMLGridBackground"].tap()

        // Snapshot
        snapshot("SelectElementViewPortrait")

        // Tap edit element button to open edit sheet
        app.buttons["EditElementButton"].tap()

        // Snapshot
        snapshot("EditElementViewPortrait")

        // Close element edit sheet
        app.buttons["Done"].tap()

        // Tap add element button
        app.buttons["AddElementButton"].tap()
        
        // Snapshot
        snapshot("DiagramDisplayViewPortrait")

        // Tap add element button to close menu
        app.buttons["AddElementButton"].forceTapElement()

        // Tap diagram menu
        app.buttons["DiagramMenuButton"].forceTapElement()

        // Tap export diagram button
        app.buttons["DiagramExportButton"].forceTapElement()

        // Snapshot
        snapshot("DiagramExportButtonPortrait")
    }

    func testTakeLandscapeScreenshots() {
        app.launchArguments += ["-dark_mode", "NO"]
        XCUIDevice.shared.orientation = .landscapeRight
        app.launch()

        // Snapshot
        snapshot("DiagramListViewLandscape")

        // Tap diagram
        app.buttons["DiagramNavigationButton_1"].tap()

        // Sleep
        sleep(3)

        // Tap random location on screen to select element
        app.images["UMLGridBackground"].tap()

        // Snapshot
        snapshot("SelectElementViewLandscape")

        // Tap edit element button to open edit sheet
        app.buttons["EditElementButton"].tap()

        // Snapshot
        snapshot("EditElementViewLandscape")

        // Close element edit sheet
        app.buttons["Done"].tap()

        // Tap add element button
        app.buttons["AddElementButton"].tap()

        // Snapshot
        snapshot("DiagramDisplayViewLandscape")

        // Tap add element button to close menu
        app.buttons["AddElementButton"].forceTapElement()

        // Tap diagram menu
        app.buttons["DiagramMenuButton"].forceTapElement()

        // Tap export diagram button
        app.buttons["DiagramExportButton"].forceTapElement()

        // Snapshot
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
