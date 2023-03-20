//
//  GalleryView.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

struct GalleryView: View {
    @EnvironmentObject var dataStore: DataStore
    @Binding var media: Media?

    var body: some View {
        VStack {
            if media != nil {
                MediaView(media: media!)
            } else {
                VStack {
                    Image(systemName: "photo.stack")
                        .imageScale(.large)
                        .foregroundColor(.gray)
                        .padding(2.0)
                    Text("No Media")
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
                dataStore.goToPrevious()
            },
            HotkeyCombination(keyBase: [], key: .kVK_RightArrow) {
                dataStore.goToNext()
            }
        ])
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView(media: .constant(Media(URL(fileURLWithPath: "/Users/michaelenger/Downloads/DDfX1SX.jpeg"))))
            .environmentObject(DataStore())
            .frame(width: 300.0, height: 300.0)
        GalleryView(media: .constant(nil))
            .environmentObject(DataStore())
            .frame(width: 300.0, height: 300.0)
    }
}
