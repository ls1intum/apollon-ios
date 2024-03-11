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
    func testTakeDarkModePortraitScreenshots() {
        XCUIDevice.shared.orientation = .portrait
        app.launchArguments += ["-ColorScheme", "Dark"]
        app.launch()

        // Tap Diagram
        app.buttons["DiagramNavigationButton_1"].tap()

        // Sleep
        sleep(1)

        // Snapshot
        snapshot("DiagramDisplayViewPortraitDarkMode")
    }

    @MainActor
    func testTakePortraitScreenshots() {
        XCUIDevice.shared.orientation = .portrait
        app.launchArguments += ["-ColorScheme", "Light"]
        app.launch()

        // Snapshot
        snapshot("DiagramListViewPortrait")

        // Tap diagram
        app.buttons["DiagramNavigationButton_1"].tap()

        // Sleep
        sleep(1)

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

    @MainActor
    func testTakeLandscapeScreenshots() {
        XCUIDevice.shared.orientation = .landscapeRight
        app.launchArguments += ["-ColorScheme", "Light"]
        app.launch()

        // Snapshot
        snapshot("DiagramListViewLandscape")

        // Tap diagram
        app.buttons["DiagramNavigationButton_1"].tap()

        // Sleep
        sleep(1)

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
