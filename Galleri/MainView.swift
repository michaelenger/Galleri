//
//  MainView.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

struct MainView: View {
    var filePath: String?

    var body: some View {
        VStack {
            if self.filePath != nil {
                MediaView(filePath: filePath!)
            } else {
                VStack {
                    Image(systemName: "photo")
                        .imageScale(.large)
                        .foregroundColor(.gray)
                        .padding(2.0)
                    Text("No Image")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment:.center)
        .background(.black)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(filePath: "/Users/michaelenger/Downloads/DDfX1SX.jpeg")
            .frame(width: 300.0, height: 300.0)
        MainView()
            .frame(width: 300.0, height: 300.0)
    }
}
