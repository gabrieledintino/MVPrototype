//
//  DriversListView.swift
//  MVVMPrototype
//
//  Created by Gabriele D'intino (EXT) on 16/07/24.
//

import SwiftUI

struct DriversListView: View {
    @Environment(DriversAggregate.self) internal var driversAggregate
    internal let inspection = Inspection<Self>()

    @State var searchText = ""
    
    var filteredDrivers: [Driver] {
        if searchText.isEmpty {
            return driversAggregate.drivers
        } else {
            return driversAggregate.drivers.filter { $0.fullName.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if driversAggregate.isLoading {
                    ProgressView()
                        .accessibilityIdentifier("progress_view")
                } else if let errorMessage = driversAggregate.errorMessage {
                    ErrorView(message: errorMessage)
                        .accessibilityIdentifier("error_view")
                } else {
                    driversList
                }
            }
            .navigationTitle("F1 Drivers")
            .navigationDestination(for: Driver.self) { driver in
                DriverDetailView(driver: driver)
            }
        }
        .searchable(text: $searchText, prompt: "Search drivers")
        .task {
            await driversAggregate.fetchDrivers()
        }
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
    
    private var driversList: some View {
        List(filteredDrivers, id: \.driverID) { driver in
            NavigationLink(value: driver) {
                DriverRow(driver: driver)
                    .accessibilityIdentifier("DriverCell_\(driver.driverID)")
            }
        }
        .accessibilityIdentifier("list_view")
    }
}

struct DriverRow: View {
    let driver: Driver
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(driver.fullName)
                .font(.headline)
            Text(driver.nationality)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            Text("Error")
                .font(.title)
                .padding()
            Text(message)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}


#Preview {
    DriversListView()
}
