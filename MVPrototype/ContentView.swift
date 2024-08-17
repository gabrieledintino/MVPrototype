//
//  ContentView.swift
//  MVPrototype
//
//  Created by Gabriele D'Intino on 15/08/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DriversListView()
                .tabItem {
                    Label("Drivers", systemImage: "person.3")
                }
            
            FavoriteDriversView()
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
        }
    }
}

#Preview {
    ContentView()
}
