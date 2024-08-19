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
    
    func testRemoveFavorites() throws {
        // Given
        sut.favoriteIDs = ["driver1", "driver2"]
        
        // When
        sut.removeFavorites(at: IndexSet(integer: 0))
        
        // Then
        XCTAssertEqual(sut.favoriteIDs, ["driver2"])
    }
}
