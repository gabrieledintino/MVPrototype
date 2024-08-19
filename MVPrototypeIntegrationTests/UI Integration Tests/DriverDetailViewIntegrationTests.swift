//
//  DriverDetailViewIntegrationTests.swift
//  MVPrototypeIntegrationTests
//
//  Created by Gabriele D'Intino on 19/08/24.
//

import XCTest
import ViewInspector

final class DriverDetailViewIntegrationTests: XCTestCase {
    var drivers: [Driver]!
    var driverResponse: DriversListYearResponse!
    var raceResults: [Race]!
    var originalDriversAggreggate: DriversAggregate!
    var sut: DriverDetailView!
    
    override func setUp() {
        super.setUp()
        
        driverResponse = try! FileUtils.loadJSONData(from: "drivers", withExtension: "json", in: type(of: self))
        drivers = driverResponse.mrData.driverTable.drivers
        let resultsResponse: RaceResultResponse = try! FileUtils.loadJSONData(from: "leclerc_results", withExtension: "json", in: type(of: self))
        raceResults = resultsResponse.mrData.raceTable.races
        
        originalDriversAggreggate = DriversAggregate()
        sut = DriverDetailView(driver: drivers.first!)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testProgressViewIsShownAndOthersHidden() throws {
        originalDriversAggreggate.isLoadingRaces = true
        let exp = sut.inspection.inspect() { view in
            XCTAssertFalse(try view.find(viewWithAccessibilityIdentifier: "progress_view").isHidden())
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "detail_text_view"))
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "error_view"))
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "list_view"))
        }
        ViewHosting.host(view: sut.environment(originalDriversAggreggate))
        wait(for: [exp], timeout: 0.1)
    }
    
    func testErrorViewIsShownAndOthersHidden() throws {
        originalDriversAggreggate.errorMessageRaces = "Test error"

        let exp = sut.inspection.inspect() { view in
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "progress_view"))
            XCTAssertFalse(try view.find(viewWithAccessibilityIdentifier: "error_view").isHidden())
            XCTAssertEqual(try view.list().section(1).view(ErrorView.self, 0).vStack().image(0).actualImage().name(), "exclamationmark.triangle")
            XCTAssertEqual(try view.list().section(1).view(ErrorView.self, 0).vStack().text(1).string(), "Error")
            XCTAssertEqual(try view.list().section(1).view(ErrorView.self, 0).vStack().text(2).string(), "Test error")
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "detail_text_view"))
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "list_view"))
        }
        ViewHosting.host(view: sut.environment(originalDriversAggreggate))
        wait(for: [exp], timeout: 0.1)
    }
    
    func testDriverListIsEmptyShowsText() throws {
        let exp = sut.inspection.inspect() { view in
            try view.actualView().races = []
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "progress_view"))
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "error_view"))
            XCTAssertFalse(try view.find(viewWithAccessibilityIdentifier: "detail_text_view").isHidden())
            XCTAssertEqual(try view.list().section(1).text(0).string(), "No race results available.")
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "list_view"))
        }
        ViewHosting.host(view: sut.environment(originalDriversAggreggate))
        wait(for: [exp], timeout: 0.1)
    }
    
    func testDriverListIsShownAndOthersHidden() throws {
        let exp = sut.inspection.inspect() { view in
            try view.actualView().races = [self.raceResults[0], self.raceResults[1], self.raceResults[2]]
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "progress_view"))
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "error_view"))
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "detail_text_view"))
            XCTAssertFalse(try view.find(viewWithAccessibilityIdentifier: "list_view").isHidden())
            XCTAssertEqual(try view.list().section(1).forEach(0).count, 3)
        }
        ViewHosting.host(view: sut.environment(originalDriversAggreggate))
        wait(for: [exp], timeout: 0.9)
    }
    
    func testResultRowIsRendered() throws {
        let exp = sut.inspection.inspect() { view in
            try view.actualView().races = [self.raceResults[0]]
            XCTAssertNoThrow(try view.list().section(1).forEach(0).view(RaceResultRow.self, 0))
            XCTAssertThrowsError(try view.list().section(1).forEach(0).view(RaceResultRow.self, 1))
        }
        ViewHosting.host(view: sut.environment(originalDriversAggreggate))
        wait(for: [exp], timeout: 0.1)
    }

}
