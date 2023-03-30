//
//  QLImage.swift
//  Galleri
//
//  Created by Michael Enger on 28/03/2023.
//

import Quartz
import SwiftUI

/// An image view that uses the Quick Look API. From: https://stackoverflow.com/a/70369611
struct QLImage: NSViewRepresentable {
    var url: URL

    func makeNSView(context: NSViewRepresentableContext<QLImage>) -> QLPreviewView {
        let preview = QLPreviewView(frame: .zero, style: .normal)
        preview?.autostarts = true
        preview?.previewItem = url as QLPreviewItem

        return preview ?? QLPreviewView()
    }

    func updateNSView(_ nsView: QLPreviewView, context: NSViewRepresentableContext<QLImage>) {
        nsView.previewItem = url as QLPreviewItem
    }

    typealias NSViewType = QLPreviewView
}
