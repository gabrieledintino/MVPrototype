//
//  NetworkClientTests.swift
//  MVVMPrototypeTests
//
//  Created by Gabriele D'intino (EXT) on 22/07/24.
//

import XCTest
@testable import MVPrototype

final class NetworkClientTests: XCTestCase {
    var sut: NetworkClient!
    var session: URLSession!
    
    var drivers: [Driver]!
    var driverResponse: DriversListYearResponse!
    var raceResults: [Race]!
    var resultsResponse: RaceResultResponse!
    
    override func setUp() {
        super.setUp()
        URLProtocol.registerClass(URLProtocolStub.self)
        
        session = {
            let configuration = URLSessionConfiguration.ephemeral
            configuration.protocolClasses = [URLProtocolStub.self]
            return URLSession(configuration: configuration)
        }()
        sut = NetworkClient(urlSession: session)
        
        
        driverResponse = try! FileUtils.loadJSONData(from: "drivers", withExtension: "json", in: type(of: self))
        drivers = driverResponse.mrData.driverTable.drivers
        resultsResponse = try! FileUtils.loadJSONData(from: "leclerc_results", withExtension: "json", in: type(of: self))
        raceResults = resultsResponse.mrData.raceTable.races
    }
    
    override func tearDown() {
        sut = nil
        session = nil
        super.tearDown()
    }
    
    func testFetchDriversSuccess() async throws {
        let mockData = try JSONEncoder().encode(driverResponse)
        let url = URL(string: "https://ergast.com/api/f1/2024/drivers.json")!
        URLProtocolStub.stub(url: url, data: mockData, response: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!, error: nil)
        let sutDrivers = try await sut.fetchDrivers()
        XCTAssertEqual(sutDrivers, drivers)
    }
    
    func testFetchResultsSuccess() async throws {
        let mockData = try JSONEncoder().encode(resultsResponse)
        let url = URL(string: "https://ergast.com/api/f1/2024/drivers/leclerc/results.json")!
        URLProtocolStub.stub(url: url, data: mockData, response: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!, error: nil)
        let sutResults = try await sut.fetchRaceResults(forDriver: "leclerc")
        XCTAssertEqual(sutResults, raceResults)
    }
    
    func testFetchDriversThrowsNetworkError() async throws {        
        let error = NSError(domain: "Network Error", code: 1)
        let url = URL(string: "https://ergast.com/api/f1/2024/drivers.json")!
        URLProtocolStub.stub(url: url, data: nil, response: HTTPURLResponse(url: url, statusCode: 503, httpVersion: nil, headerFields: nil)!, error: error)
        
        do {
            _ = try await sut.fetchDrivers()
            XCTFail("The test should throw a server error for an error response.")
        } catch let error as APIError {
            switch error {
            case .networkError:
                break
            default:
                XCTFail("The test should throw a server error for an error response.")
            }
        } catch {
            XCTFail("The test should throw a server error for an error response.")
        }
    }
    
    func testFetchResultsThrowsNetworkError() async throws {
        let error = NSError(domain: "Network Error", code: 1)
        let url = URL(string: "https://ergast.com/api/f1/2024/drivers/leclerc/results.json")!
        URLProtocolStub.stub(url: url, data: nil, response: HTTPURLResponse(url: url, statusCode: 503, httpVersion: nil, headerFields: nil)!, error: error)
        
        do {
            _ = try await sut.fetchRaceResults(forDriver: "leclerc")
            XCTFail("The test should throw a server error for an error response.")
        } catch let error as APIError {
            switch error {
            case .networkError:
                break
            default:
                XCTFail("The test should throw a server error for an error response.")
            }
        } catch {
            XCTFail("The test should throw a server error for an error response.")
        }
    }
    
    func testFetchDriversDecodingError() async throws {
        let mockResponse = "bad data"
        let mockData = mockResponse.data(using: .utf8)
        
        let url = URL(string: "https://ergast.com/api/f1/2024/drivers.json")!
        URLProtocolStub.stub(url: url, data: mockData, response: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!, error: nil)
        
        do {
            _ = try await sut.fetchDrivers()
            XCTFail("The test should throw a decoding error for an error response.")
        } catch let error as APIError {
            switch error {
            case .decodingError:
                break
            default:
                XCTFail("The test should throw a decoding error for an error response.")
            }
        } catch {
            XCTFail("The test should throw a decoding error for an error response.")
        }
    }
    
    func testFetchResultsDecodingError() async throws {
        let mockResponse = "bad data"
        let mockData = mockResponse.data(using: .utf8)
        
        let url = URL(string: "https://ergast.com/api/f1/2024/drivers/leclerc/results.json")!
        URLProtocolStub.stub(url: url, data: mockData, response: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!, error: nil)
        
        do {
            _ = try await sut.fetchRaceResults(forDriver: "leclerc")
            XCTFail("The test should throw a decoding error for an error response.")
        } catch let error as APIError {
            switch error {
            case .decodingError:
                break
            default:
                XCTFail("The test should throw a decoding error for an error response.")
            }
        } catch {
            XCTFail("The test should throw a decoding error for an error response.")
        }
    }
}

// Helper function to assert errors in async functions
func XCTAssertThrowsErrorAsync<T>(_ expression: @autoclosure @escaping () async throws -> T, _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line, _ errorHandler: (Error) -> Void) async {
    do {
        _ = try await expression()
        XCTFail("Expected error but got none", file: file, line: line)
    } catch {
        errorHandler(error)
    }
}
