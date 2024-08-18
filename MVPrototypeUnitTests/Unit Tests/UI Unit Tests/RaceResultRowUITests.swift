//
//  RaceResultRowUITests.swift
//  MVVMPrototypeTests
//
//  Created by Gabriele D'intino (EXT) on 10/08/24.
//

import XCTest
import SwiftUI
import ViewInspector

final class RaceResultRowUITests: XCTestCase {
    var raceResults: [Race]!

    override func setUp() {
        super.setUp()

        let resultsResponse: RaceResultResponse = try! FileUtils.loadJSONData(from: "leclerc_results", withExtension: "json", in: type(of: self))
        raceResults = resultsResponse.mrData.raceTable.races
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testDriverRowIsRenderedCorrectly() throws {
        let resultRow = RaceResultRow(race: raceResults.first!, driverID: "leclerc")
        let hStack = try resultRow.inspect().hStack()
        let firstVstack = try hStack.vStack(0)
        let secondVstack = try hStack.vStack(2)
        
        // test padding
        XCTAssertEqual(try hStack.padding(.vertical), 4)
        
        // test first VStack
        XCTAssertEqual(try firstVstack.alignment(), .leading)
        XCTAssertEqual(try firstVstack.spacing(), 4)
        XCTAssertEqual(try firstVstack.text(0).string(), "Bahrain Grand Prix")
        XCTAssertEqual(try firstVstack.text(1).string(), "02-03-2024 16:00")

        // test second VStack
        XCTAssertEqual(try secondVstack.alignment(), .trailing)
        XCTAssertEqual(try secondVstack.spacing(), 4)
        let innerHStackText = try secondVstack.hStack(0).text(0)
        XCTAssertEqual(try innerHStackText.string(), "4")
        XCTAssertEqual(try innerHStackText.attributes().font().size(), 18)
        XCTAssertEqual(try innerHStackText.attributes().font().weight(), .bold)
        XCTAssertGreaterThanOrEqual(try innerHStackText.flexFrame().minWidth, 25)
        XCTAssertEqual(try innerHStackText.padding(.all), 6)
        XCTAssertEqual(try innerHStackText.background().color().value(), Color.blue)
        XCTAssertEqual(try innerHStackText.attributes().foregroundColor(), .white)
        XCTAssertEqual(try innerHStackText.cornerRadius(), CGFloat(6.0))
        
        XCTAssertEqual(try secondVstack.hStack(0).text(1).string(), "12 pts")
        XCTAssertEqual(try secondVstack.hStack(0).text(1).attributes().fontWeight(), .semibold)
        
        XCTAssertEqual(try secondVstack.text(1).string(), "Started: P2")
        XCTAssertEqual(try secondVstack.text(1).attributes().font(), .subheadline)
        XCTAssertEqual(try secondVstack.text(1).attributes().foregroundColor(), .secondary)
    }
    
    func testDriverRowNotPodiumPositionColorIsCorrect() throws {
        let resultRow = RaceResultRow(race: raceResults.first!, driverID: "leclerc")
        let hStack = try resultRow.inspect().hStack()
        let secondVstack = try hStack.vStack(2)

        let innerHStackText = try secondVstack.hStack(0).text(0)
        XCTAssertEqual(try innerHStackText.background().color().value(), Color.blue)
    }
    
    func testDriverRowThirdPlacePositionColorIsCorrect() throws {
        let resultRow = RaceResultRow(race: raceResults[1], driverID: "leclerc")
        let hStack = try resultRow.inspect().hStack()
        let secondVstack = try hStack.vStack(2)

        let innerHStackText = try secondVstack.hStack(0).text(0)
        XCTAssertEqual(try innerHStackText.background().color().value(), Color.orange)
    }
    
    func testDriverRowSecondPlacePositionColorIsCorrect() throws {
        let resultRow = RaceResultRow(race: raceResults[2], driverID: "leclerc")
        let hStack = try resultRow.inspect().hStack()
        let secondVstack = try hStack.vStack(2)

        let innerHStackText = try secondVstack.hStack(0).text(0)
        XCTAssertEqual(try innerHStackText.background().color().value(), Color.gray)
    }
    
    func testDriverRowFirstPlacePositionColorIsCorrect() throws {
        let resultRow = RaceResultRow(race: raceResults[7], driverID: "leclerc")
        let hStack = try resultRow.inspect().hStack()
        let secondVstack = try hStack.vStack(2)

        let innerHStackText = try secondVstack.hStack(0).text(0)
        XCTAssertEqual(try innerHStackText.background().color().value(), Color.yellow)
    }
    
    func testFormattedDateWhenBadlyFormatted() throws {
        let raceString = """
                {
                    "season": "2024",
                    "round": "1",
                    "url": "https://en.wikipedia.org/wiki/2024_Bahrain_Grand_Prix",
                    "raceName": "Bahrain Grand Prix",
                    "Circuit": {
                        "circuitId": "bahrain",
                        "url": "http://en.wikipedia.org/wiki/Bahrain_International_Circuit",
                        "circuitName": "Bahrain International Circuit",
                        "Location": {
                            "lat": "26.0325",
                            "long": "50.5106",
                            "locality": "Sakhir",
                            "country": "Bahrain"
                        }
                    },
                    "date": "XXX",
                    "time": "YYY",
                    "Results": [
                        {
                            "number": "16",
                            "position": "4",
                            "positionText": "4",
                            "points": "12",
                            "Driver": {
                                "driverId": "leclerc",
                                "permanentNumber": "16",
                                "code": "LEC",
                                "url": "http://en.wikipedia.org/wiki/Charles_Leclerc",
                                "givenName": "Charles",
                                "familyName": "Leclerc",
                                "dateOfBirth": "1997-10-16",
                                "nationality": "Monegasque"
                            },
                            "Constructor": {
                                "constructorId": "ferrari",
                                "url": "http://en.wikipedia.org/wiki/Scuderia_Ferrari",
                                "name": "Ferrari",
                                "nationality": "Italian"
                            },
                            "grid": "2",
                            "laps": "57",
                            "status": "Finished",
                            "Time": {
                                "millis": "5544411",
                                "time": "+39.669"
                            },
                            "FastestLap": {
                                "rank": "2",
                                "lap": "36",
                                "Time": {
                                    "time": "1:34.090"
                                },
                                "AverageSpeed": {
                                    "units": "kph",
                                    "speed": "207.069"
                                }
                            }
                        }
                    ]
                }
"""
        let jsonData = raceString.data(using: .utf8)!
        let race: Race = try JSONDecoder().decode(Race.self, from: jsonData)
        let resultRow = RaceResultRow(race: race, driverID: "leclerc")
        XCTAssertEqual(try resultRow.inspect().hStack().vStack(0).text(1).string(), "XXX YYY")
    }
}
