/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2020C
  Assessment: Final Project
  Author: Team 1 
  Created  date: 01/01/2020 
  Last modified: 26/01/2020
  Acknowledgement: Acknowledge the resources that you use here. 
*/


import UIKit
import SwiftUI
import Combine
import RichEditorView
import FirebaseStorage

struct TextEditorView: UIViewControllerRepresentable {
    var initContent: String
    @Binding var noteContent: String
// Creates the custom instance that you use to communicate changes from your view controller to other parts of your SwiftUI interface.
    func makeCoordinator() -> Coordinator {
        return Coordinator(noteContent: $noteContent)
    }
    //Creates the view controller object and configures its initial state
    func makeUIViewController(context: Context) -> EditorViewController {
        let editorView = EditorViewController()
        editorView.noteContent = initContent
        editorView.richEditorViewDelegate = context.coordinator
        return editorView
    }
// Updates the state of the specified view controller with new information from SwiftUI.
    func updateUIViewController(_ uiViewController: EditorViewController, context: Context){
    }
}
// callbacks for the delegate of the RichEditorView
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
// A set of methods that your delegate object must implement to interact with the image picker interface.
// Navigation controller delegate to modify behavior when a view controller is pushed or popped from the navigation stack
class EditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var editorView = RichEditorView()
    var isTextColor = true
    var noteContent = String()
    var richEditorViewDelegate: RichEditorDelegate? = nil
    
    var url: String = ""
    var attachmentName: String = ""
// works in asynchronously and thread/queue safety
// get albums ( + all photos album)
// optimized for fast scrolling
// get images with defined size
    private lazy var pickerController : UIImagePickerController = {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image", "public.movie"]
        pickerController.sourceType = .photoLibrary
        return pickerController
    }()
// The toolbar for user easy to edit the text in the note
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        toolbar.options = RichEditorDefaultOption.all
        return toolbar
    }()
// Called regardless of whether the view hierarchy was loaded from a nib file or created programmatically in the loadView() method. You usually override this method to perform additional initialization on views that were loaded from nib files.
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
    
// This function help user import the phote to the note by local photo book
// The controller object managing the image picker interface.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        pickerController.dismiss(animated: true, completion: nil)
// upload image to server and get url here
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        if let originalImage = originalImage {
            if let resziedImage = originalImage.resized(width: view.frame.width - 40) {
                if let data = resziedImage.pngData() {
                    uploadPhoto(data: data) {(url) in
                        if let url = url {
                            self.attachmentName = UUID().uuidString
                            self.url = url.absoluteString
                            self.toolbar.editor?.insertImage(self.url, alt: self.attachmentName)
                        }
                    }
                }
            }
        }
    }
    
    func uploadPhoto(data: Data, completion: @escaping (URL?)-> Void) {
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference()
        let photoRef = storageRef.child("images/\(imageName).png")
        
        photoRef.putData(data, metadata: nil) { metadata, error in
            photoRef.downloadURL { (url, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("upload at \(String(describing: url?.absoluteString))")
                    completion(url)
                }
            }
        }
    }
// Tells the delegate that the user cancelled the pick operation.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerController.dismiss(animated: true, completion: nil)
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
/*Using this on a UIImage that is a property of a UIImageView the pixel coordinates are those of the actual image in its original resolution, not the screen coordinates of the scaled UIImageView.
Also it tried with RGB Jpg and RGBA PNG and the both get imported as 32 bit RGBA images so it works for both.*/
    private func getRGBA(from color: UIColor) -> [CGFloat] {
        var R: CGFloat = 0
        var G: CGFloat = 0
        var B: CGFloat = 0
        var A: CGFloat = 0
        
        color.getRed(&R, green: &G, blue: &B, alpha: &A)
        
        return [R, G, B, A]
    }
    
// Check the color set for a background on a UIImageView
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
        self.present(pickerController, animated: true, completion: nil)
    }

// the function of change color in the toolbar of note
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
