//
//  DriverDetailViewUITests.swift
//  MVVMPrototypeUITests
//
//  Created by Gabriele D'intino (EXT) on 06/08/24.
//

import XCTest

final class DriverDetailViewUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["UI-Testing"]
        app.launch()
    }
    
    func testDriverInformationDisplay() throws {
        // Wait for the list to load
        let firstDriverCell = app.cells.firstMatch
        XCTAssertTrue(firstDriverCell.waitForExistence(timeout: 5))
        // Navigate to DriverDetailView
        app.buttons["DriverCell_leclerc-DriverCell_leclerc"].tap()
        
        let fullNameText = app.staticTexts["Full Name"]
        let fullNameValue = app.staticTexts["Charles Leclerc"]
        
        XCTAssertTrue(fullNameText.exists)
        XCTAssertTrue(fullNameValue.exists)
        
        let nationalityText = app.staticTexts["Nationality"]
        let nationalityValue = app.staticTexts["Monegasque"]
        
        XCTAssertTrue(nationalityText.exists)
        XCTAssertTrue(nationalityValue.exists)
        
        let dobText = app.staticTexts["Date of Birth"]
        let dobValue = app.staticTexts["1997-10-16"]
        
        XCTAssertTrue(dobText.exists)
        XCTAssertTrue(dobValue.exists)
        
        let driverNumberText = app.staticTexts["Driver Number"]
        let driverNumberValue = app.staticTexts["16"]
        
        XCTAssertTrue(driverNumberText.exists)
        XCTAssertTrue(driverNumberValue.exists)
    }
    
    func testRaceResultsDisplay() throws {
        // Wait for the list to load
        let firstDriverCell = app.cells.firstMatch
        XCTAssertTrue(firstDriverCell.waitForExistence(timeout: 5))
        // Navigate to DriverDetailView
        app.buttons["DriverCell_leclerc-DriverCell_leclerc"].tap()
        
        // Check if the "Race Results for current season" section exists
        let raceResultsSection = app.staticTexts["RACE RESULTS FOR CURRENT SEASON"]
        XCTAssertTrue(raceResultsSection.exists)
        
        // Check for the existence of specific race results
        let bahrainGP = app.staticTexts["Bahrain Grand Prix"]
        XCTAssertTrue(bahrainGP.waitForExistence(timeout: 5))
        
        let bahrainPosition = app.staticTexts["4"]
        XCTAssertTrue(bahrainPosition.exists)
        
        let bahrainPoints = app.staticTexts["12 pts"]
        XCTAssertTrue(bahrainPoints.exists)
    }
    
    func testFavoriteButtonFunctionality() throws {
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
        
        // Check if the button image changed to filled star
        let filledStarButton = app.navigationBars["Charles Leclerc"].buttons["star.fill"]
        XCTAssertTrue(filledStarButton.exists)
        
        // Tap again to unfavorite
        filledStarButton.tap()
        
        // Check if the button image changed back to empty star
        XCTAssertTrue(favoriteButton.exists)
    }
}
