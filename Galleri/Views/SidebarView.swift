//
//  SidebarView.swift
//  Galleri
//
//  Created by Michael Enger on 19/03/2023.
//

import SwiftUI

struct SidebarView: View {
    @Environment(DataStore.self) private var dataStore
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
            .contextMenu {
                Section {
                    Button("Move Up") {
                        dataStore.moveMediaUp(media.id)
                    }
                    Button("Move Down") {
                        dataStore.moveMediaDown(media.id)
                    }
                }
                Section {
                    Button("Move To Top") {
                        dataStore.moveMediaToTop(media.id)
                    }
                    Button("Move To Bottom") {
                        dataStore.moveMediaToBottom(media.id)
                    }
                }
                Section {
                    Button("Remove") {
                        dataStore.removeMedia(media.id)
                    }
                }
            }
        }
        .listStyle(SidebarListStyle())
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(selection: .constant("one"))
            .environment({ () -> DataStore in
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
