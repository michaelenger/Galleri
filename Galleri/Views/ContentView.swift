//
//  ContentView.swift
//  Galleri
//
//  Created by Michael Enger on 19/03/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataStore: DataStore

    var body: some View {
        NavigationView {
            SidebarView(selection: $dataStore.selectedMediaID)
            MediaView(media: $dataStore[dataStore.selectedMediaID])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject({ () -> DataStore in
                let envObj = DataStore()
                envObj.loadMedia(from: [
                    URL(fileURLWithPath: "/Users/michaelenger/Downloads/DDfX1SX.jpeg"),
                    URL(fileURLWithPath: "/Users/michaelenger/Downloads/dikbut.png"),
                ])
                return envObj
            }() )
    }
}
