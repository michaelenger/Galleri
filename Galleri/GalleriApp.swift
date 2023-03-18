//
//  GalleriApp.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

@main
struct GalleriApp: App {
    @StateObject var dataStore = DataStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataStore)
        }
    }
}
