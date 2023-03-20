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

    var body: some View {
        VStack {
            if media != nil {
                ImageView(media: media!)
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

struct MediaView_Previews: PreviewProvider {
    static var previews: some View {
        MediaView(media: .constant(Media(URL(fileURLWithPath: "/Users/michaelenger/Downloads/DDfX1SX.jpeg"))))
            .environmentObject(DataStore())
            .frame(width: 300.0, height: 300.0)
        MediaView(media: .constant(nil))
            .environmentObject(DataStore())
            .frame(width: 300.0, height: 300.0)
    }
}
