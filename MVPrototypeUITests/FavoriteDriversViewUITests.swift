//
//  FavoriteDriversViewUITests.swift
//  MVVMPrototypeUITests
//
//  Created by Gabriele D'intino (EXT) on 07/08/24.
//

import XCTest

class FavoriteDriversViewUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testInitialViewRendering() throws {
        XCUIApplication().tabBars["Tab Bar"].buttons["Favorites"].tap()
        
        // Check if the navigation title is correct
        XCTAssertTrue(app.navigationBars["Favorite Drivers"].exists)
    }
    
    func testEmptyStateMessageDisplayed() throws {
        XCUIApplication().tabBars["Tab Bar"].buttons["Favorites"].tap()
        
        let emptyStateMessage = app.staticTexts["No favorite drivers yet"]
        XCTAssertTrue(emptyStateMessage.exists, "Empty state message should be displayed when there are no favorite drivers")
    }
    
    func testFavoriteDriversListDisplayedAndNavigationWorks() throws {
        // Wait for the list to load
        let firstDriverCell = app.cells.firstMatch
        XCTAssertTrue(firstDriverCell.waitForExistence(timeout: 5))
        // Navigate to DriverDetailView
        app.buttons["DriverCell_leclerc-DriverCell_leclerc"].tap()
        
        // Find the favorite button
        let favoriteButton = app.navigationBars["Charles Leclerc"].buttons["star"]
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 5))
        
        // Tap the favorite button
        favoriteButton.tap()
        XCUIApplication().tabBars["Tab Bar"].buttons["Favorites"].tap()
        
        let favoriteDriversList = app.cells.firstMatch
        XCTAssertTrue(favoriteDriversList.waitForExistence(timeout: 5), "Favorite drivers list should be displayed when there are favorite drivers")
        
        // Check if there are cells in the list
        XCTAssertGreaterThan(app.cells.count, 0, "There should be at least one driver in the favorites list")
        // Get the name of the first driver
        let firstDriverName = favoriteDriversList.firstMatch.staticTexts.element(boundBy: 0).label
        XCTAssertEqual(firstDriverName, "Charles Leclerc")
        favoriteDriversList.firstMatch.tap()
        XCTAssertTrue(app.navigationBars[firstDriverName].exists)

        // Check if the button image changed to filled star
        let filledStarButton = app.navigationBars[firstDriverName].buttons["star.fill"]
        XCTAssertTrue(filledStarButton.exists)
        
        // Tap again to unfavorite
        filledStarButton.tap()
        
        // Check that the app is back on the main favorite tab
        XCTAssertTrue(app.navigationBars["Favorite Drivers"].exists)
    }
}
