//
//  SidebarView.swift
//  Galleri
//
//  Created by Michael Enger on 19/03/2023.
//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var dataStore: DataStore

    var body: some View {
        List(dataStore.mediaItems) { media in
            HStack {
                Spacer()
                Image(nsImage: media.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 90)
                Spacer()
            }
            .padding()
//            .background(.gray)
//            .cornerRadius(20)
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
            .environmentObject({ () -> DataStore in
                let envObj = DataStore()
                envObj.loadMedia(from: [
                    URL(fileURLWithPath: "/Users/michaelenger/Downloads/DDfX1SX.jpeg"),
                    URL(fileURLWithPath: "/Users/michaelenger/Downloads/dikbut.png"),
                ])
                return envObj
            }() )
            .frame(width: 300, height: 300)
    }
}
