//
//  GoToView.swift
//  Galleri
//
//  Created by Michael Enger on 23/03/2023.
//

import SwiftUI

struct GoToView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(DataStore.self) private var dataStore

    @State var imageText: String = ""

    var body: some View {
        VStack {
            HStack {
                Text("Go to:")
                TextField("", text: $imageText)
                    .onSubmit {
                        goToAndDismiss()
                    }
            }

            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Spacer()
                Button("OK") {
                    goToAndDismiss()
                }
            }
        }
        .padding()
        .frame(width: 140)
    }
}

extension GoToView {
    func goToAndDismiss() {
        let targetIndex = Int(imageText)
        if targetIndex != nil {
            dataStore.goTo(targetIndex!)
            dismiss()
        }
    }
}

struct GoToView_Previews: PreviewProvider {
    static var previews: some View {
        GoToView()
            .environment({ () -> DataStore in
                let envObj = DataStore()
                envObj.loadMedia(from: [
                    Bundle.main.url(forResource: "example", withExtension: "jpeg")!,
                    Bundle.main.url(forResource: "grid", withExtension: "png")!,
                ])
                return envObj
            }() )
    }
}
