//
//  DriversAggregate.swift
//  MVPrototype
//
//  Created by Gabriele D'Intino on 16/08/24.
//

import Foundation

@Observable class DriversAggregate {
    var drivers: [Driver] = []
    //var searchText = ""
    var isLoading = false
    var isLoadingRaces = false
    var errorMessage: String?
    var errorMessageRaces: String?
    
    private let networkClient: NetworkClientProtocol
        
    init(networkClient: NetworkClientProtocol = NetworkClient.shared) {
        self.networkClient = networkClient
    }
    
    func fetchDrivers() async {
        isLoading = true
        errorMessage = nil
        
        do {
            drivers = try await networkClient.fetchDrivers()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func fetchRaceResults(driver: Driver) async -> [Race] {
        isLoadingRaces = true
        errorMessageRaces = nil
        
        do {
            let response = try await networkClient.fetchRaceResults(forDriver: driver.driverID)
            isLoadingRaces = false
            return response
        } catch {
            errorMessageRaces = error.localizedDescription
            isLoadingRaces = false
            return []
        }
    }
}
