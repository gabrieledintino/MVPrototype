//
//  ConstructorsView.swift
//  MVVMPrototype
//
//  Created by Gabriele D'intino (EXT) on 16/07/24.
//

import SwiftUI

struct FavoriteDriversView: View {
    @Environment(DriversAggregate.self) private var driversAggregate
    @AppStorage("FavoriteDrivers") var favoriteIDs: [String] = []
    internal let inspection = Inspection<Self>()
    
    var favoriteDrivers: [Driver] {
        return driversAggregate.drivers.filter { favoriteIDs.contains($0.driverID) }
    }

    var body: some View {
        NavigationView {
            ZStack {
                if driversAggregate.isLoading {
                    ProgressView()
                        .accessibilityIdentifier("progress_view")
                } else if let errorMessage = driversAggregate.errorMessage {
                    ErrorView(message: errorMessage)
                        .accessibilityIdentifier("error_view")
                } else if favoriteDrivers.isEmpty {
                    Text("No favorite drivers yet")
                        .foregroundColor(.secondary)
                        .accessibilityIdentifier("text_view")
                } else {
                    favoriteDriversList
                }
            }
            .navigationTitle("Favorite Drivers")
        }
        .task {
            await driversAggregate.fetchDrivers()
        }
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
    
    private var favoriteDriversList: some View {
        List {
            ForEach(favoriteDrivers, id: \.driverID) { driver in
                NavigationLink(destination: DriverDetailView(driver: driver)) {
                    DriverRow(driver: driver)
                }
            }
            .onDelete(perform: removeFavorites)
            .accessibilityIdentifier("list_view")
        }
    }
    
    func removeFavorites(at offsets: IndexSet) {
        favoriteIDs.remove(atOffsets: offsets)
    }
}

#Preview {
    FavoriteDriversView()
}
