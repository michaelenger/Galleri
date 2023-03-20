//
//  MediaView.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

struct MediaView: View {
    @EnvironmentObject var dataStore: DataStore
    @Binding var media: Media?
    @Binding var isFullscreen: Bool

    var body: some View {
        VStack {
            if media != nil {
                GeometryReader { geometry in
                    ScrollView([.horizontal, .vertical]) {
                        ImageView(
                            media: media!,
                            parentFrameSize: geometry.size
                        )
                    }
                }
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
            }
        ])
    }
}

struct MediaView_Previews: PreviewProvider {
    static var previews: some View {
        MediaView(
            media: .constant(Media(URL(fileURLWithPath: "/Users/michaelenger/Downloads/DDfX1SX.jpeg"))),
            isFullscreen: .constant(false)
        )
            .environmentObject(DataStore())
            .frame(width: 300.0, height: 300.0)
        MediaView(
            media: .constant(nil),
            isFullscreen: .constant(false)
        )
            .environmentObject(DataStore())
            .frame(width: 300.0, height: 300.0)
    }
}
