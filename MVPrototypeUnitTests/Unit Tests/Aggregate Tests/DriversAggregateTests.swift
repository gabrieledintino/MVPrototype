//
//  DriversAggregateTests.swift
//  MVPrototypeTests
//
//  Created by Gabriele D'Intino on 18/08/24.
//

import XCTest
@testable import MVPrototype
import Cuckoo

final class DriversAggregateTests: XCTestCase {
        var drivers: [Driver]!
        var leclercDriver: Driver!
        var driverResponse: DriversListYearResponse!
        var raceResults: [Race]!
        var mockNetworkClient: MockNetworkClientProtocol!
        var sut: DriversAggregate!
    
        override func setUp() {
            super.setUp()
            mockNetworkClient = MockNetworkClientProtocol()
            sut = DriversAggregate(networkClient: mockNetworkClient)
    
            driverResponse = try! FileUtils.loadJSONData(from: "drivers", withExtension: "json", in: type(of: self))
            drivers = driverResponse.mrData.driverTable.drivers
            leclercDriver = driverResponse.mrData.driverTable.drivers.first(where: { $0.driverID == "leclerc" })
            let resultsResponse: RaceResultResponse = try! FileUtils.loadJSONData(from: "leclerc_results", withExtension: "json", in: type(of: self))
            raceResults = resultsResponse.mrData.raceTable.races
        }
    
        override func tearDown() {
            sut = nil
            mockNetworkClient = nil
            super.tearDown()
        }
    
        func testFetchDriversSuccess() async throws {
            // Given
            stub(mockNetworkClient) { stub in
              when(stub.fetchDrivers()).then { _ in
                  return self.drivers
              }
            }
    
            // When
            await sut.fetchDrivers()
    
            // Then
            XCTAssertFalse(sut.isLoading)
            XCTAssertNil(sut.errorMessage)
            XCTAssertFalse(sut.isLoadingRaces)
            XCTAssertNil(sut.errorMessageRaces)
            XCTAssertEqual(sut.drivers, drivers)
            verify(mockNetworkClient).fetchDrivers()
            verifyNoMoreInteractions(mockNetworkClient)
        }
    
        func testFetchDriversFailure() async {
            // Given
            let expectedError = NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Network error"])
    
            stub(mockNetworkClient) { stub in
              when(stub.fetchDrivers()).then { _ in
                  throw expectedError
              }
            }
            // When
            await sut.fetchDrivers()
    
            // Then
            XCTAssertFalse(sut.isLoading)
            XCTAssertEqual(sut.errorMessage, expectedError.localizedDescription)
            XCTAssertFalse(sut.isLoadingRaces)
            XCTAssertNil(sut.errorMessageRaces)
            XCTAssertTrue(sut.drivers.isEmpty)
            verify(mockNetworkClient).fetchDrivers()
            verifyNoMoreInteractions(mockNetworkClient)
        }
    
    func testFetchRacesSuccess() async throws {
        // Given
        stub(mockNetworkClient) { stub in
            when(stub.fetchRaceResults(forDriver: "leclerc")).thenReturn(self.raceResults)
        }

        // When
        let methodResult = await sut.fetchRaceResults(driver: leclercDriver)

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoadingRaces)
        XCTAssertNil(sut.errorMessageRaces)
        XCTAssertEqual(methodResult, raceResults)
        verify(mockNetworkClient).fetchRaceResults(forDriver: "leclerc").with(returnType: [Race].self)
        verifyNoMoreInteractions(mockNetworkClient)
    }

    func testFetchRacesFailure() async {
        // Given
        let expectedError = NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Network error"])

        stub(mockNetworkClient) { stub in
            when(stub.fetchRaceResults(forDriver: "leclerc")).thenThrow(expectedError)
        }
        // When
        let methodResult = await sut.fetchRaceResults(driver: leclercDriver)

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoadingRaces)
        XCTAssertEqual(sut.errorMessageRaces, expectedError.localizedDescription)
        XCTAssertEqual(methodResult, [])
        verify(mockNetworkClient).fetchRaceResults(forDriver: "leclerc")
        verifyNoMoreInteractions(mockNetworkClient)
    }
}
