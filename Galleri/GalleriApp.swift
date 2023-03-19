//
//  GalleriApp.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

@main
struct GalleriApp: App {
    @NSApplicationDelegateAdaptor(DataStore.self) var dataStore

    var body: some Scene {
        Window("Galleri", id: "main") {
            ContentView()
                .environmentObject(dataStore)
                .onAppear {
                    NSWindow.allowsAutomaticWindowTabbing = false
                }
                //.handlesExternalEvents(preferring: Set(arrayLiteral: "pause"), allowing: Set(arrayLiteral: "*"))  // not sure if this is needed
        }
        .commands() {
            FileCommands(dataStore: dataStore)
            GoCommands(dataStore: dataStore)
        }
        .handlesExternalEvents(matching: Set(arrayLiteral: "*"))
    }
}
