import UIKit
import SwiftUI
import Combine
import RichEditorView

struct TextEditorView: UIViewControllerRepresentable {
    var initContent: String
    @Binding var noteContent: String
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(noteContent: $noteContent)
    }
    
    func makeUIViewController(context: Context) -> EditorViewController {
        let editorView = EditorViewController()
        editorView.noteContent = initContent
        editorView.richEditorViewDelegate = context.coordinator
        return editorView
    }

    func updateUIViewController(_ uiViewController: EditorViewController, context: Context){
    }
}

class Coordinator: NSObject, RichEditorDelegate {
    @Binding var noteContent: String
    
    init(noteContent: Binding<String>) {
        _noteContent = noteContent
    }
    
    func richEditor(_ editor: RichEditorView, heightDidChange height: Int) { }

    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        noteContent = content
    }

    func richEditorTookFocus(_ editor: RichEditorView) { }
    
    func richEditorLostFocus(_ editor: RichEditorView) { }
    
    func richEditorDidLoad(_ editor: RichEditorView) {
        noteContent = editor.contentHTML;
    }
    
    func richEditor(_ editor: RichEditorView, shouldInteractWith url: URL) -> Bool { return true }

    func richEditor(_ editor: RichEditorView, handleCustomAction content: String) { }
}

class EditorViewController: UIViewController {
    var editorView = RichEditorView()
    var isTextColor = true
    var noteContent = String()
    var richEditorViewDelegate: RichEditorDelegate? = nil
    
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        toolbar.options = RichEditorDefaultOption.all
        return toolbar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        additionalSafeAreaInsets = .init(top: 6, left: 12, bottom: 0, right: 12)
        editorView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        editorView.center.x = view.center.x
        editorView.delegate = richEditorViewDelegate
        editorView.inputAccessoryView = toolbar
        editorView.placeholder = "Edit here"
        let html = noteContent
        editorView.reloadHTML(with: html)
        
        toolbar.delegate = self
        toolbar.editor = editorView

        // This will create a custom action that clears all the input text when it is pressed
        let item = RichEditorOptionItem(title: "Clear") { (toolbar, sender) in
            toolbar.editor?.html = ""
        }

        var options = toolbar.options
        options.append(item)
        toolbar.options = options
        
        // add note title textview heres
        self.view.addSubview(editorView)
        self.view.addSubview(toolbar)
        toolbar.frame.origin.y = self.view.frame.size.height - 215 - toolbar.frame.size.height
    }
}

extension EditorViewController: RichEditorToolbarDelegate, UIColorPickerViewControllerDelegate {
    private func presentColorPicker(title: String?, color: UIColor?) {
        let picker = UIColorPickerViewController()
        picker.supportsAlpha = false
        picker.delegate = self
        picker.title = title
        if let color = color {
            picker.selectedColor = color
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    private func getRGBA(from color: UIColor) -> [CGFloat] {
        var R: CGFloat = 0
        var G: CGFloat = 0
        var B: CGFloat = 0
        var A: CGFloat = 0
        
        color.getRed(&R, green: &G, blue: &B, alpha: &A)
        
        return [R, G, B, A]
    }
    
    private func isBlackOrWhite(_ color: UIColor) -> Bool {
        let RGBA = getRGBA(from: color)
        let isBlack = RGBA[0] < 0.09 && RGBA[1] < 0.09 && RGBA[2] < 0.09
        let isWhite = RGBA[0] > 0.91 && RGBA[1] > 0.91 && RGBA[2] > 0.91
        
        return isBlack || isWhite
    }
    
    func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar, sender: AnyObject) {
        isTextColor = true
        presentColorPicker(title: "Text Color", color: .black)
    }

    func richEditorToolbarChangeBackgroundColor(_ toolbar: RichEditorToolbar, sender: AnyObject) {
        isTextColor = false
        presentColorPicker(title: "Background Color", color: .white)
    }

    func richEditorToolbarInsertImage(_ toolbar: RichEditorToolbar) {
        // do insert image here, get url
        
        toolbar.editor?.insertImage("https://avatars2.githubusercontent.com/u/10981?s=60", alt: "Gravatar")
    }

    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        var color: UIColor? = viewController.selectedColor
        
        // don't allow black or white color changes
        if isBlackOrWhite(viewController.selectedColor) {
            color = nil
        }

        if isTextColor {
            toolbar.editor?.setTextColor(color)
        } else {
            toolbar.editor?.setTextBackgroundColor(color)
        }
    }
}