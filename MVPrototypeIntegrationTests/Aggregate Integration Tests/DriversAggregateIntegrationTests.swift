//
//  DriversAggregateIntegrationTests.swift
//  MVPrototypeIntegrationTests
//
//  Created by Gabriele D'Intino on 19/08/24.
//

import XCTest
import Cuckoo

final class DriversAggregateIntegrationTests: XCTestCase {
    var drivers: [Driver]!
    var driverResponse: DriversListYearResponse!
    var raceResults: [Race]!
    var sut: DriversAggregate!
    var spy: MockNetworkClientProtocol!

    override func setUp() {
        super.setUp()
        spy = MockNetworkClientProtocol()
        spy.enableDefaultImplementation(NetworkClient())
        sut = DriversAggregate(networkClient: spy)
        
        driverResponse = try! FileUtils.loadJSONData(from: "drivers", withExtension: "json", in: type(of: self))
        drivers = driverResponse.mrData.driverTable.drivers
        let resultsResponse: RaceResultResponse = try! FileUtils.loadJSONData(from: "leclerc_results", withExtension: "json", in: type(of: self))
        raceResults = resultsResponse.mrData.raceTable.races
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testFetchDriversSuccess() async throws {
        // When
        await sut.fetchDrivers()
        
        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoadingRaces)
        XCTAssertNil(sut.errorMessageRaces)
        XCTAssertEqual(sut.drivers, drivers)
        verify(spy).fetchDrivers()
        verifyNoMoreInteractions(spy)
    }
    
    func testFetchRacesSuccess() async throws {
        // When
        let result = await sut.fetchRaceResults(driver: drivers.first(where: { $0.driverID == "leclerc" })! )
        
        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoadingRaces)
        XCTAssertNil(sut.errorMessageRaces)
        XCTAssertEqual(result, raceResults)
        verify(spy).fetchRaceResults(forDriver: "leclerc")
        verifyNoMoreInteractions(spy)
    }

}
