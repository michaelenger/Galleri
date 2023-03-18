//
//  ContentView.swift
//  Galleri
//
//  Created by Michael Enger on 18/03/2023.
//

import SwiftUI

struct ContentView: View {
    var image: NSImage?

    init(filePath: String) {
        let imageUrl = URL(fileURLWithPath: filePath)
        self.image = NSImage(contentsOf: imageUrl)
    }

    var body: some View {
        VStack {
            if self.image != nil {
                Image(nsImage: self.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(filePath: "/Users/michaelenger/Downloads/DDfX1SX.jpeg")
            .frame(width: 500.0, height: 500.0)
    }
}
