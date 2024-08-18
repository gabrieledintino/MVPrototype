//
//  FavorireDriversViewUITests.swift
//  MVVMPrototypeTests
//
//  Created by Gabriele D'intino (EXT) on 10/08/24.
//

import XCTest
import ViewInspector
@testable import MVPrototype
import SwiftUI
import Cuckoo

final class FavoriteDriversViewUITests: XCTestCase {
    var drivers: [Driver]!
    var driverResponse: DriversListYearResponse!
    var originalDriversAggreggate: DriversAggregate!
    var sut: FavoriteDriversView!
    
    override func setUp() {
        super.setUp()
        
        driverResponse = try! FileUtils.loadJSONData(from: "drivers", withExtension: "json", in: type(of: self))
        drivers = driverResponse.mrData.driverTable.drivers
        
        originalDriversAggreggate = DriversAggregate()
        sut = FavoriteDriversView()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testProgressViewIsShownAndOthersHidden() throws {
        originalDriversAggreggate.isLoading = true
        let exp = sut.inspection.inspect() { view in
            XCTAssertFalse(try view.find(viewWithAccessibilityIdentifier: "progress_view").isHidden())
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "text_view"))
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "error_view"))
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "list_view"))
        }
        ViewHosting.host(view: sut.environment(originalDriversAggreggate))
        wait(for: [exp], timeout: 0.1)
    }
    
    func testErrorViewIsShownAndOthersHidden() throws {
        originalDriversAggreggate.errorMessage = "Test error"
        let exp = sut.inspection.inspect() { view in
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "progress_view"))
            XCTAssertFalse(try view.find(viewWithAccessibilityIdentifier: "error_view").isHidden())
            XCTAssertEqual(try view.navigationView().zStack().view(ErrorView.self, 0).vStack().image(0).actualImage().name(), "exclamationmark.triangle")
            XCTAssertEqual(try view.navigationView().zStack().view(ErrorView.self, 0).vStack().text(1).string(), "Error")
            XCTAssertEqual(try view.navigationView().zStack().view(ErrorView.self, 0).vStack().text(2).string(), "Test error")
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "text_view"))
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "list_view"))

        }
        ViewHosting.host(view: sut.environment(originalDriversAggreggate))
        wait(for: [exp], timeout: 0.1)
    }
    
    func testDriverListIsEmptyShowsText() throws {
        originalDriversAggreggate.drivers = []
        let exp = sut.inspection.inspect() { view in
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "progress_view"))
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "error_view"))
            XCTAssertFalse(try view.find(viewWithAccessibilityIdentifier: "text_view").isHidden())
            XCTAssertEqual(try view.navigationView().zStack().text(0).string(), "No favorite drivers yet")
            XCTAssertEqual(try view.navigationView().zStack().text(0).attributes().foregroundColor(), .secondary)
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "list_view"))
        }
        ViewHosting.host(view: sut.environment(originalDriversAggreggate))
        wait(for: [exp], timeout: 0.1)
    }
    
    func testRemoveFavorites() throws {
        // Given
        sut.favoriteIDs = ["driver1", "driver2"]
        
        // When
        sut.removeFavorites(at: IndexSet(integer: 0))
        
        // Then
        XCTAssertEqual(sut.favoriteIDs, ["driver2"])
    }
}
