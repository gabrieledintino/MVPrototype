//
//  NetworkClientProtocol.swift
//  MVVMPrototype
//
//  Created by Gabriele D'intino (EXT) on 19/07/24.
//

import Foundation

protocol NetworkClientProtocol {
    func fetchDrivers() async throws -> [Driver]
    func fetchRaceResults(forDriver driverId: String) async throws -> [Race]
}
