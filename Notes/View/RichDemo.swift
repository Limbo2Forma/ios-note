//
//  ViewController.swift
//  RichEditorViewSample
//
//  Created by Caesar Wirth on 4/5/15.
//  Copyright (c) 2015 Caesar Wirth. All rights reserved.
//

import UIKit
import SwiftUI
import RichEditorView

class RichDemo: UIViewController {
    
    @IBOutlet var editorView: RichEditorView!
    
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        toolbar.options = RichEditorDefaultOption.all
        return toolbar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        editorView.delegate = self
        editorView.inputAccessoryView = toolbar

        toolbar.delegate = self
        toolbar.editor = editorView

        // We will create a custom action that clears all the input text when it is pressed
        let item = RichEditorOptionItem(image: nil, title: "Clear") { toolbar in
            toolbar.editor?.html = ""
        }

        var options = toolbar.options
        options.append(item)
        toolbar.options = options
    }

}

extension RichDemo: RichEditorDelegate {
    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
//        print(content)
    }
}

extension RichDemo: RichEditorToolbarDelegate {

    fileprivate func randomColor() -> UIColor {
        let colors: [UIColor] = [
            .red,
            .orange,
            .yellow,
            .green,
            .blue,
            .purple
        ]
        
        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        return color
    }

    func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextColor(color)
    }

    func richEditorToolbarChangeBackgroundColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextBackgroundColor(color)
    }

    func richEditorToolbarInsertImage(_ toolbar: RichEditorToolbar) {
        toolbar.editor?.insertImage("https://gravatar.com/avatar/696cf5da599733261059de06c4d1fe22", alt: "Gravatar")
    }

    func richEditorToolbarInsertLink(_ toolbar: RichEditorToolbar) {
        // Can only add links to selected text, so make sure there is a range selection first
        if ((toolbar.editor?.hasRangeSelection) != nil) {
            toolbar.editor?.insertLink(href: "http://github.com/cjwirth/RichEditorView", text: "Github Link")
        }
    }
}

struct RichDemoRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = RichDemo
    
    func makeUIViewController(context: Context) -> RichDemo {
        UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateViewController(withIdentifier: "RichDemo") as! RichDemo
    }
    
    func updateUIViewController(_ uiViewController: RichDemo, context: Context) {
        
    }
}
