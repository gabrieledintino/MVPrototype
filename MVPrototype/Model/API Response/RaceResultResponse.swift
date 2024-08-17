//
//  Race.swift
//  MVVMPrototype
//
//  Created by Gabriele D'intino (EXT) on 16/07/24.
//

import Foundation

// MARK: - RaceResultResponse
struct RaceResultResponse: Codable {
    let mrData: MRDataResults

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

// MARK: - MRData
struct MRDataResults: Codable {
    let xmlns: String
    let series: String
    let url: String
    let limit, offset, total: String
    let raceTable: RaceTable

    enum CodingKeys: String, CodingKey {
        case xmlns, series, url, limit, offset, total
        case raceTable = "RaceTable"
    }
}

// MARK: - RaceTable
struct RaceTable: Codable {
    let season: String
    let round: String?
    let races: [Race]

    enum CodingKeys: String, CodingKey {
        case season, round
        case races = "Races"
    }
}

// MARK: - Race
struct Race: Codable, Equatable {
    let season, round: String
    let url: String
    let raceName: String
    let circuit: Circuit
    let date, time: String
    let results: [Result]

    enum CodingKeys: String, CodingKey {
        case season, round, url, raceName
        case circuit = "Circuit"
        case date, time
        case results = "Results"
    }
}

// MARK: - Result
struct Result: Codable, Equatable {
    let number, position, positionText, points: String
    let driver: Driver
    let constructor: Constructor
    let grid, laps, status: String
    let time: ResultTime?
    let fastestLap: FastestLap?

    enum CodingKeys: String, CodingKey {
        case number, position, positionText, points
        case driver = "Driver"
        case constructor = "Constructor"
        case grid, laps, status
        case time = "Time"
        case fastestLap = "FastestLap"
    }
}

// MARK: - Constructor
struct Constructor: Codable, Equatable {
    let constructorID: String
    let url: String
    let name, nationality: String

    enum CodingKeys: String, CodingKey {
        case constructorID = "constructorId"
        case url, name, nationality
    }
}

// MARK: - FastestLap
struct FastestLap: Codable, Equatable {
    let rank, lap: String
    let time: FastestLapTime
    let averageSpeed: AverageSpeed

    enum CodingKeys: String, CodingKey {
        case rank, lap
        case time = "Time"
        case averageSpeed = "AverageSpeed"
    }
}

// MARK: - AverageSpeed
struct AverageSpeed: Codable, Equatable {
    let units: Units
    let speed: String
}

enum Units: String, Codable, Equatable {
    case kph = "kph"
}

// MARK: - FastestLapTime
struct FastestLapTime: Codable, Equatable {
    let time: String
}

// MARK: - ResultTime
struct ResultTime: Codable, Equatable {
    let millis, time: String
}

