//
//  ContentView.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataStore: DataStore

    var body: some View {
        VStack {
            if dataStore.currentMediaUrl != nil {
                MediaView(mediaUrl: dataStore.currentMediaUrl!)
            } else {
                VStack {
                    Image(systemName: "photo")
                        .imageScale(.large)
                        .foregroundColor(.gray)
                        .padding(2.0)
                    Text("No Image")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment:.center)
        .background(.black)
        .addCustomHotkeys([
            HotkeyCombination(keyBase: [], key: .kVK_LeftArrow ) {
                dataStore.previousMedia()
            },
            HotkeyCombination(keyBase: [], key: .kVK_RightArrow) {
                dataStore.nextMedia()
            }
        ])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject({ () -> DataStore in
                let envObj = DataStore()
                envObj.currentMediaUrl = URL(fileURLWithPath: "/Users/michaelenger/Downloads/DDfX1SX.jpeg")
                return envObj
            }() )
            .frame(width: 300.0, height: 300.0)
        ContentView()
            .environmentObject(DataStore())
            .frame(width: 300.0, height: 300.0)
    }
}
