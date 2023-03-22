//
//  DetailView.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var dataStore: DataStore
    @Binding var media: Media?
    @Binding var isFullscreen: Bool

    var body: some View {
        VStack {
            if media != nil {
                ScrollableImageView(media: media!)
            } else {
                Image(systemName: "photo.stack")
                    .imageScale(.large)
                    .foregroundColor(.gray)
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment:.center)
        .background(isFullscreen ? .black : .clear)
        .addCustomHotkeys([
            HotkeyCombination(keyBase: [], key: .kVK_LeftArrow ) {
                dataStore.goToPrevious()
            },
            HotkeyCombination(keyBase: [], key: .kVK_RightArrow) {
                dataStore.goToNext()
            },
            HotkeyCombination(keyBase: [], key: .kVK_Space) {
                dataStore.goToNext()
            }
        ])
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(
            media: .constant(Media(URL(fileURLWithPath: "/Users/michaelenger/Downloads/DDfX1SX.jpeg"))),
            isFullscreen: .constant(false)
        )
        .environmentObject(DataStore())
        .frame(width: 300.0, height: 300.0)

        DetailView(
            media: .constant(nil),
            isFullscreen: .constant(false)
        )
        .environmentObject(DataStore())
        .frame(width: 300.0, height: 300.0)
    }
}
