//
//  InfoRowUITests.swift
//  MVVMPrototypeTests
//
//  Created by Gabriele D'intino (EXT) on 10/08/24.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import MVPrototype

final class InfoRowUITests: XCTestCase {

    func testInfoRowContent() throws {
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
        
        let driverRow = InfoRow(title: "Full Name", value: mockDriver.fullName)
        
        let hStack = try driverRow.inspect().hStack()
        
        // Test the title
        let titleText = try hStack.text(0)
        XCTAssertEqual(try titleText.string(), "Full Name")
        XCTAssertEqual(try titleText.attributes().fontWeight(), .semibold)
        
        // Test the value
        let valueText = try hStack.text(2)
        XCTAssertEqual(try valueText.string(), "Charles Leclerc")
        //XCTAssertEqual(try valueText.attributes().font(), .subheadline)
        //XCTAssertEqual(try valueText.attributes().foregroundColor(), .secondary)
    }

}
