import XCTest

class ApollonSnapshotUITests: XCTestCase {
    var app: XCUIApplication!

    @MainActor
    override func setUp() {
        app = XCUIApplication()
        setupSnapshot(app)
        app.launchArguments += ["-Screenshots"]
    }

    @MainActor
    func testTakeScreenshots() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            XCUIDevice.shared.orientation = .portrait
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIDevice.shared.orientation = .landscapeRight
        }
        app.launchArguments += ["-ColorScheme", "Light"]
        app.launch()

        // Snapshot 01
        snapshot("01DiagramListView")

        // Tap diagram
        app.buttons["DiagramNavigationButton_1"].tap()

        // Sleep
        sleep(1)

        // Tap random location on screen to select element
        app.images["UMLGridBackground"].tap()

        // Snapshot 02
        snapshot("02SelectElementView")

        // Tap edit element button to open edit sheet
        app.buttons["EditElementButton"].tap()

        // Snapshot 03
        snapshot("03EditElementView")

        // Close element edit sheet
        app.buttons["Done"].tap()

        // Tap add element button
        app.buttons["AddElementButton"].tap()

        // Snapshot 04
        snapshot("04DiagramDisplayView")

        // Tap add element button to close menu
        app.buttons["AddElementButton"].forceTapElement()

        // Tap diagram menu
        app.buttons["DiagramMenuButton"].forceTapElement()

        // Tap export diagram button
        app.buttons["DiagramExportButton"].forceTapElement()

        // Snapshot 05
        snapshot("05DiagramExportButton")
    }

    @MainActor
    func testTakeDarkModeScreenshots() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            XCUIDevice.shared.orientation = .portrait
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIDevice.shared.orientation = .landscapeRight
        }
        app.launchArguments += ["-ColorScheme", "Dark"]
        app.launch()

        // Tap Diagram
        app.buttons["DiagramNavigationButton_1"].tap()

        // Sleep
        sleep(1)

        // Snapshot 06
        snapshot("06DiagramDisplayViewDarkMode")
    }
}

// Sends a tap event to a unhittable element
// https://stackoverflow.com/questions/33422681/xcode-ui-test-ui-testing-failure-failed-to-scroll-to-visible-by-ax-action
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
