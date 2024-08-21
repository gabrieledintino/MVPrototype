//
//  DriversListViewIntegrationTests.swift
//  MVPrototypeIntegrationTests
//
//  Created by Gabriele D'Intino on 18/08/24.
//

import XCTest
import ViewInspector
@testable import MVPrototype
import SwiftUI
import Cuckoo

final class DriversListViewIntegrationTests: XCTestCase {
    var drivers: [Driver]!
    var driverResponse: DriversListYearResponse!
    var originalDriversAggreggate: DriversAggregate!
    var sut: DriversListView!
    
    override func setUp() {
        super.setUp()
        
        driverResponse = try! FileUtils.loadJSONData(from: "drivers", withExtension: "json", in: type(of: self))
        drivers = driverResponse.mrData.driverTable.drivers
        
        originalDriversAggreggate = DriversAggregate()
        sut = DriversListView()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitialState() throws {
        let exp = sut.inspection.inspect() { view in
            XCTAssertFalse(try view.actualView().driversAggregate.isLoading)
            XCTAssertFalse(try view.actualView().driversAggregate.errorMessage != nil)
            XCTAssertEqual(try view.actualView().driversAggregate.drivers, [])
        }
        ViewHosting.host(view: sut.environment(originalDriversAggreggate))
        wait(for: [exp], timeout: 0.1)
    }
      
    func testProgressViewIsShownAndOthersHidden() throws {
        originalDriversAggreggate.isLoading = true
        let exp = sut.inspection.inspect() { view in
            XCTAssertTrue(try view.actualView().driversAggregate.isLoading)
            XCTAssertFalse(try view.find(viewWithAccessibilityIdentifier: "progress_view").isHidden())
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
            XCTAssertEqual(try view.navigationStack().zStack().view(ErrorView.self, 0).vStack().image(0).actualImage().name(), "exclamationmark.triangle")
            XCTAssertEqual(try view.navigationStack().zStack().view(ErrorView.self, 0).vStack().text(1).string(), "Error")
            XCTAssertEqual(try view.navigationStack().zStack().view(ErrorView.self, 0).vStack().text(2).string(), "Test error")
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "list_view"))
        }
        ViewHosting.host(view: sut.environment(originalDriversAggreggate))
        wait(for: [exp], timeout: 0.1)
    }
    
    func testDriverListIsShownAndOthersHidden() throws {
        let exp = sut.inspection.inspect(after: 5.0) { view in
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "progress_view"))
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "error_view"))
            XCTAssertFalse(try view.find(viewWithAccessibilityIdentifier: "list_view").isHidden())
        }
        ViewHosting.host(view: sut.environment(originalDriversAggreggate))
        wait(for: [exp], timeout: 5.0)
    }
    
    func testDriverRowIsRenderedCorrectly() throws {
        let exp = sut.inspection.inspect(after: 5.0) { view in
            XCTAssertEqual(try view.navigationStack().zStack().list(0).forEach(0).navigationLink(0).labelView().view(DriverRow.self).vStack().text(0).string(), "Alexander Albon")
            XCTAssertEqual(try view.navigationStack().zStack().list(0).forEach(0).navigationLink(0).labelView().view(DriverRow.self).vStack().text(1).string(), "Thai")
            XCTAssertEqual(try view.navigationStack().zStack().list(0).forEach(0).navigationLink(1).labelView().view(DriverRow.self).vStack().text(0).string(), "Fernando Alonso")
            XCTAssertEqual(try view.navigationStack().zStack().list(0).forEach(0).navigationLink(1).labelView().view(DriverRow.self).vStack().text(1).string(), "Spanish")
        }
        ViewHosting.host(view: sut.environment(originalDriversAggreggate))
        wait(for: [exp], timeout: 5.0)
    }
}
