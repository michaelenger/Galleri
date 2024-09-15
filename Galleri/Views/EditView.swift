//
//  EditView.swift
//  Galleri
//
//  Created by Michael Enger on 15/09/2024.
//

import SwiftUI

struct EditView: View {
    @Environment(DataStore.self) private var dataStore

    @State
    private var active: Media?

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 200, maximum: 500), spacing: 20)], spacing: 20) {
                ReorderableForEach(dataStore.mediaItems, active: $active) { item in
                    Image(nsImage: item.image)
                        .resizable()
                        .scaledToFit()
                        .border(.secondary)
                        .contextMenu {
                            Button(action: {
                                dataStore.removeMedia(item.id)
                            }, label: { Label("Remove", systemImage: "icon") })
                        }
                } moveAction: { from, to in
                    dataStore.mediaItems.move(fromOffsets: from, toOffset: to)
                }
            }.padding()
        }
        .scrollContentBackground(.hidden)
        .reorderableForEachContainer(active: $active)
    }
}

#Preview {
    EditView()
        .environment({ () -> DataStore in
            let envObj = DataStore()
            envObj.loadMedia(from: [
                Bundle.main.url(forResource: "example", withExtension: "jpeg")!,
                Bundle.main.url(forResource: "grid", withExtension: "png")!,
                Bundle.main.url(forResource: "longcat", withExtension: "jpg")!,
                Bundle.main.url(forResource: "squid", withExtension: "gif")!,
            ])
            return envObj
        }() )
        .frame(width: 800.0, height: 600.0)
}
