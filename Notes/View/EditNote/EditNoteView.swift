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
import SwiftUI
import Firebase

// This fuction to user edit the note such as show or share the note

struct EditNoteView : View {
    
    var note: Note?
    var destination: String
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var data: FirestoreDb
    
    @State private var title = ""
    @State private var noteContent = ""
    @State var showAddNoteToFolder = false
    @State var isShareToSocialMedia = false
    var body : some View{
        VStack() {
            TextField("Note Title", text: $title)
                .padding(10)
                .font(.title)
            Divider()
            TextEditorView(initContent: note?.content ?? "", noteContent: $noteContent)
        }
        .onAppear {
            self.title = note?.title ?? ""
        }
        .navigationBarTitle(Text(note?.title ?? "New Note"), displayMode: .inline) // title navigation bar
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $showAddNoteToFolder, content: {
            NavigationView {
                FolderPicker(note: note!,folders: data.folders, showPicker: $showAddNoteToFolder)
            }
        })
        .sheet(isPresented: $isShareToSocialMedia, content: {
            ActivityViewController(activityItems: [note!.title, note!.content])
        })
        .onDisappear(perform: {
            if (note == nil) {
                data.createNote(title: self.title, content: self.noteContent, destination: destination)
            } else {
                var noteUpdate = self.note
                noteUpdate?.title = self.title
                noteUpdate?.content = self.noteContent
                data.updateNote(note: noteUpdate!)
            }
        })
        .navigationBarItems(trailing:
            HStack(spacing: 20) {
                if (note != nil) {
                    // create the button for add note to folder
                    Button(action: { self.showAddNoteToFolder = true }) {
                        Image(systemName: "note.text.badge.plus")
                            .resizable().frame(width: 26, height: 23).foregroundColor(Color.blue)
                                .font(Font.title.weight(.thin))
                    }
                    // create the button for share the note in social media such as facebook, whatApps, ...
                    Button(action: { self.isShareToSocialMedia.toggle()}) {
                        Image(systemName: "square.and.arrow.up.on.square.fill")
                            .resizable().frame(width: 23, height: 26).foregroundColor(Color.blue)
                                .font(Font.title.weight(.thin))
                    }
                }
            })
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
    
}
