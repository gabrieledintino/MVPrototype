//
//  Circuit.swift
//  MVVMPrototype
//
//  Created by Gabriele D'intino (EXT) on 16/07/24.
//

import Foundation

// MARK: - CircuitListYearResponse
struct CircuitListYearResponse: Codable {
    let mrData: MRDataCircuits

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

// MARK: - MRData
struct MRDataCircuits: Codable {
    let xmlns: String
    let series: String
    let url: String
    let limit, offset, total: String
    let circuitTable: CircuitTable

    enum CodingKeys: String, CodingKey {
        case xmlns, series, url, limit, offset, total
        case circuitTable = "CircuitTable"
    }
}

// MARK: - CircuitTable
struct CircuitTable: Codable {
    let season: String
    let circuits: [Circuit]

    enum CodingKeys: String, CodingKey {
        case season
        case circuits = "Circuits"
    }
}

// MARK: - Circuit
struct Circuit: Codable, Equatable {
    let circuitID: String
    let url: String
    let circuitName: String
    let location: Location

    enum CodingKeys: String, CodingKey {
        case circuitID = "circuitId"
        case url, circuitName
        case location = "Location"
    }
}

// MARK: - Location
struct Location: Codable, Equatable {
    let lat, long, locality, country: String
}
