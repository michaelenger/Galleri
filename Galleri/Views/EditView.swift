//
//  EditView.swift
//  Galleri
//
//  Created by Michael Enger on 15/09/2024.
//

import SwiftUI

struct EditView: View {
    @Environment(DataStore.self) private var dataStore
    @State private var active: Media?

    var body: some View {
        let activeBinding = Binding<Media?>(
            get: { active },
            set: {
                active = $0

                if active != nil {
                    dataStore.selectedMediaID = active!.id
                }
            })

        ScrollView(.vertical) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 200, maximum: 500), spacing: 20)], spacing: 20) {
                ReorderableForEach(dataStore.mediaItems, active: activeBinding) { item in
                    GridItemView(item: item, isSelected: item.id == dataStore.selectedMediaID)
                        .onTapGesture {
                            dataStore.selectedMediaID = item.id
                        }
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
        .reorderableForEachContainer(active: activeBinding)
    }
}

struct GridItemView: View {
    @Environment(\.colorScheme) var colorScheme

    let item: Media
    let isSelected: Bool

    var body: some View {
        let opacity = isSelected ? 1 : 0.2

        Image(nsImage: item.image)
            .resizable()
            .scaledToFit()
            .background(colorScheme == .dark ? nil : Color.white)
            .padding(2)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(colorScheme == .dark ? .white.opacity(opacity) : .black.opacity(opacity), lineWidth: 2)
            )
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
