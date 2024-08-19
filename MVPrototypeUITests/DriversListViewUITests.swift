//
//  DriversListViewUITests.swift
//  MVVMPrototypeUITests
//
//  Created by Gabriele D'intino (EXT) on 05/08/24.
//

import XCTest

final class DriversListViewUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testInitialViewRendering() throws {
        // Check if the navigation title is correct
        XCTAssertTrue(app.navigationBars["F1 Drivers"].exists)

        // Check if the search bar is present
        XCTAssertTrue(app.searchFields["Search drivers"].exists)
    }

    func testDriverListRendering() throws {
        // Wait for the list to load (adjust timeout as needed)
        let firstDriverCell = app.cells.firstMatch
        XCTAssertTrue(firstDriverCell.waitForExistence(timeout: 5))

        // Check if multiple driver cells are present
        XCTAssertTrue(app.cells.count > 1)

        // Verify the content of the first cell
        let firstDriverName = firstDriverCell.staticTexts.element(boundBy: 0).label
        let firstDriverNationality = firstDriverCell.staticTexts.element(boundBy: 1).label
        XCTAssertFalse(firstDriverName.isEmpty)
        XCTAssertFalse(firstDriverNationality.isEmpty)
        XCTAssertEqual(firstDriverName, "Alexander Albon")
        XCTAssertEqual(firstDriverNationality, "Thai")
    }

    func testSearchFunctionalitySuccess() throws {
        // Wait for the list to load
        let firstDriverCell = app.cells.firstMatch
        XCTAssertTrue(firstDriverCell.waitForExistence(timeout: 5))

        // Get the name of the first driver
        let firstDriverName = firstDriverCell.staticTexts.element(boundBy: 0).label

        // Perform a search
        let searchField = app.searchFields["Search drivers"]
        searchField.tap()
        searchField.typeText(firstDriverName)

        // Check that the search results contain the first driver
        XCTAssertTrue(app.cells.staticTexts[firstDriverName].exists)

        // Check that the number of results is reduced
        XCTAssertTrue(app.cells.count <= 1)

        // Clear the search
        searchField.buttons["Clear text"].tap()

        // Check that all drivers are shown again
        XCTAssertTrue(app.cells.count > 1)
    }
    
    func testSearchFunctionalityEmpty() throws {
        // Wait for the list to load
        let firstDriverCell = app.cells.firstMatch
        XCTAssertTrue(firstDriverCell.waitForExistence(timeout: 5))

        // Get the name of the first driver
        let searchText = "xxxx"

        // Perform a search
        let searchField = app.searchFields["Search drivers"]
        searchField.tap()
        searchField.typeText(searchText)

        // Check that the search results contain the first driver
        XCTAssertFalse(app.cells.staticTexts[searchText].exists)

        // Check that the number of results is reduced
        XCTAssertEqual(app.cells.count, 0)

        // Clear the search
        searchField.buttons["Clear text"].tap()

        // Check that all drivers are shown again
        XCTAssertTrue(app.cells.count > 1)
    }

    func testNavigationToDriverDetail() throws {
        // Wait for the list to load
        let firstDriverCell = app.cells.firstMatch
        XCTAssertTrue(firstDriverCell.waitForExistence(timeout: 5))

        // Get the name of the first driver
        let firstDriverName = firstDriverCell.staticTexts.element(boundBy: 0).label

        // Tap on the first driver
        firstDriverCell.tap()

        // Check if we've navigated to the detail view
        XCTAssertTrue(app.navigationBars[firstDriverName].exists)

        // Navigate back to the list
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // Check if we're back on the list view
        XCTAssertTrue(app.navigationBars["F1 Drivers"].exists)
    }
}
