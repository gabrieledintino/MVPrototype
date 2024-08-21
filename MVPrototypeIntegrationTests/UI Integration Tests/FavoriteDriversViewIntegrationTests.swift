//
//  FavoriteDriversViewIntegrationTests.swift
//  MVPrototypeIntegrationTests
//
//  Created by Gabriele D'Intino on 19/08/24.
//

import XCTest
import ViewInspector

final class FavoriteDriversViewIntegrationTests: XCTestCase {
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
            XCTAssertEqual(try view.navigationStack().zStack().view(ErrorView.self, 0).vStack().image(0).actualImage().name(), "exclamationmark.triangle")
            XCTAssertEqual(try view.navigationStack().zStack().view(ErrorView.self, 0).vStack().text(1).string(), "Error")
            XCTAssertEqual(try view.navigationStack().zStack().view(ErrorView.self, 0).vStack().text(2).string(), "Test error")
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
            XCTAssertEqual(try view.navigationStack().zStack().text(0).string(), "No favorite drivers yet")
            XCTAssertEqual(try view.navigationStack().zStack().text(0).attributes().foregroundColor(), .secondary)
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "list_view"))
        }
        ViewHosting.host(view: sut.environment(originalDriversAggreggate))
        wait(for: [exp], timeout: 0.1)
    }
    
    func testDriverListIsShownAndOthersHidden() throws {
        //originalDriversAggreggate.drivers = self.drivers
        sut.favoriteIDs = [self.drivers[0].driverID, self.drivers[1].driverID, self.drivers[2].driverID]
        let exp = sut.inspection.inspect(after: 5.0) { view in
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "progress_view"))
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "error_view"))
            XCTAssertThrowsError(try view.find(viewWithAccessibilityIdentifier: "text_view"))
            XCTAssertFalse(try view.find(viewWithAccessibilityIdentifier: "list_view").isHidden())
            XCTAssertEqual(try view.navigationStack().zStack().list(0).forEach(0).count, 3)
            XCTAssertThrowsError(try view.navigationView().zStack().list(0).forEach(0).navigationLink(4))
        }
        ViewHosting.host(view: sut.environment(originalDriversAggreggate))
        wait(for: [exp], timeout: 5.0)
    }
    
    func testDriverRowIsRenderedCorrectly() throws {
        originalDriversAggreggate.drivers = self.drivers
        sut.favoriteIDs = [self.drivers[0].driverID]
        let exp = sut.inspection.inspect(after: 5.0) { view in
            XCTAssertEqual(try view.navigationStack().zStack().list(0).forEach(0).navigationLink(0).labelView().view(DriverRow.self).vStack().text(0).string(), "Alexander Albon")
            XCTAssertEqual(try view.navigationStack().zStack().list(0).forEach(0).navigationLink(0).labelView().view(DriverRow.self).vStack().text(1).string(), "Thai")
        }
        ViewHosting.host(view: sut.environment(originalDriversAggreggate))
        wait(for: [exp], timeout: 5.0)
    }
}
