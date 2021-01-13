//
//  RichTextDemo2.swift
//  Notes
//
//  Created by A friend on 1/7/21.
//  Copyright © 2021 Balaji. All rights reserved.
//

import UIKit
import SwiftUI
import RichEditorView

struct TextEditorView2: UIViewRepresentable {
    @Binding var note: Note
    
    typealias UIViewType = RichEditorView
    
    func makeUIView(context: Context) -> RichEditorView {
        var editorView = RichEditorView()
        editorView.placeholder = "Edit here"
        let html = "<b>Jesus is God.</b> He saves by grace through faith alone. Soli Deo gloria! <a href='https://perfectGod.com'>perfectGod.com</a>"
        editorView.reloadHTML(with: html)
      return editorView
    }
    
    func updateUIView(_ uiView: RichEditorView, context: Context) {
//
    }
}
