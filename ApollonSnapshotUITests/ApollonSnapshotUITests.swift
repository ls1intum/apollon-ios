import XCTest

@MainActor
final class ApollonSnapshotUITests: XCTestCase {

    override func setUpWithError() throws {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func takeScreenShots() throws {
        let app = XCUIApplication()
        app.launch()
        XCUIDevice.shared.orientation = .portrait

        // Snapshot 1
        snapshot("1-DiagramListView")

        // Snapshot 2
        snapshot("2-ExportOptions")

        // Snapshot 3
        snapshot("3-DiagramView")

        // Snapshot 4
        snapshot("4-AddingElements")
    }
}
