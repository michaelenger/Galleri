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
                GeometryReader { geometry in
                    ScrollView([.horizontal, .vertical]) {
                        ImageView(
                            media: media!,
                            parentFrameSize: geometry.size
                        )
                    }
                }
            } else {
                Spacer()
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
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment:.center)
        .background(.black)
        .toolbar {
            Button(action: {
                dataStore.zoomIn()
            }) {
                Label("Zoom In", systemImage: "plus.magnifyingglass")
            }
            .disabled(media == nil)
            Button(action: {
                dataStore.zoomOut()
            }) {
                Label("Zoom Out", systemImage: "minus.magnifyingglass")
            }
            .disabled(media == nil)
            Button(action: {
                dataStore.zoomToFit()
            }) {
                Label("Zoom to Fit", systemImage: "arrow.up.left.and.down.right.and.arrow.up.right.and.down.left")
            }
            .disabled(media == nil)
        }
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
