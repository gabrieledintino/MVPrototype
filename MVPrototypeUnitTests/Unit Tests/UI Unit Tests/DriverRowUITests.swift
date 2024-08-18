//
//  DriverRowUITests.swift
//  MVVMPrototypeTests
//
//  Created by Gabriele D'intino (EXT) on 06/08/24.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import MVPrototype

final class DriverRowUITests: XCTestCase {
    
    func testDriverRowContent() throws {
        // Create a mock Driver
        let mockDriver = Driver(
            driverID: "leclerc",
            permanentNumber: "16",
            code: "LEC",
            url: "http://en.wikipedia.org/wiki/Charles_Leclerc",
            givenName: "Charles",
            familyName: "Leclerc",
            dateOfBirth: "1997-10-16",
            nationality: "Monegasque"
        )
        
        let driverRow = DriverRow(driver: mockDriver)
        
        let vStack = try driverRow.inspect().vStack()
        
        // Test the alignment of VStack
        XCTAssertEqual(try vStack.alignment(), .leading)
        
        // Test the driver's full name
        let fullNameText = try vStack.text(0)
        XCTAssertEqual(try fullNameText.string(), "Charles Leclerc")
        XCTAssertEqual(try fullNameText.attributes().font(), .headline)
        
        // Test the driver's nationality
        let nationalityText = try vStack.text(1)
        XCTAssertEqual(try nationalityText.string(), "Monegasque")
        XCTAssertEqual(try nationalityText.attributes().font(), .subheadline)
        XCTAssertEqual(try nationalityText.attributes().foregroundColor(), .secondary)
    }
    
}
