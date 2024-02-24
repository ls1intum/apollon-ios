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
        XCUIDevice.shared.orientation = .portrait
        // Snapshot 1
        snapshot("01DiagramListView")
    }
}
