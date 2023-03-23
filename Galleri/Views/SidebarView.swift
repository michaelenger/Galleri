//
//  SidebarView.swift
//  Galleri
//
//  Created by Michael Enger on 19/03/2023.
//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var dataStore: DataStore
    @Binding var selection: Media.ID?

    var body: some View {
        List(dataStore.mediaItems, selection: $selection) { media in
            HStack {
                Spacer()
                Image(nsImage: media.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                Spacer()
            }
            .padding()
        }
        .listStyle(SidebarListStyle())
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(selection: .constant("one"))
            .environmentObject({ () -> DataStore in
                let dataStore = DataStore()
                dataStore.mediaItems = [
                    Media(
                        id: "one",
                        url: Bundle.main.url(forResource: "example", withExtension: "jpeg")!
                    ),
                    Media(
                        id: "two",
                        url: Bundle.main.url(forResource: "grid", withExtension: "png")!
                    )
                ]
                return dataStore
            }() )
            .frame(width: 300, height: 300)
    }
}
