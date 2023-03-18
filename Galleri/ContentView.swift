//
//  ContentView.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

struct ContentView: View {
    var image: NSImage?

    init(filePath: String? = nil) {
        if filePath != nil {
            let imageUrl = URL(fileURLWithPath: filePath!)
            self.image = NSImage(contentsOf: imageUrl)
        } else {
            self.image = nil
        }
    }

    var body: some View {
        if self.image != nil {
            Image(nsImage: self.image!)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            VStack {
                Image(systemName: "photo")
                    .imageScale(.large)
                    .foregroundColor(.secondary)
                    .padding(2.0)
                Text("No Image")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(filePath: "/Users/michaelenger/Downloads/DDfX1SX.jpeg")
            .frame(width: 200.0, height: 200.0)
        ContentView()
            .frame(width: 200.0, height: 200.0)
    }
}
