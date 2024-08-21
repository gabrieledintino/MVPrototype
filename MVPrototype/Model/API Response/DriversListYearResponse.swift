//
//  Driver.swift
//  MVVMPrototype
//
//  Created by Gabriele D'intino (EXT) on 16/07/24.
//

import Foundation

// MARK: - DriversListResponse
struct DriversListYearResponse: Codable {
    let mrData: MRDataDrivers

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

// MARK: - MRData
struct MRDataDrivers: Codable {
    let xmlns: String
    let series: String
    let url: String
    let limit, offset, total: String
    let driverTable: DriverTable

    enum CodingKeys: String, CodingKey {
        case xmlns, series, url, limit, offset, total
        case driverTable = "DriverTable"
    }
}

// MARK: - DriverTable
struct DriverTable: Codable {
    let season: String
    let drivers: [Driver]

    enum CodingKeys: String, CodingKey {
        case season
        case drivers = "Drivers"
    }
}

// MARK: - Driver
struct Driver: Codable, Equatable, Hashable {
    let driverID, permanentNumber, code: String
    let url: String
    let givenName, familyName, dateOfBirth, nationality: String

    enum CodingKeys: String, CodingKey {
        case driverID = "driverId"
        case permanentNumber, code, url, givenName, familyName, dateOfBirth, nationality
    }
    
    var fullName: String {
        return "\(givenName) \(familyName)"
    }
}
