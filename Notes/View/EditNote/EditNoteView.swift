import SwiftUI
import Firebase

struct EditNoteView : View {
    
    var note: Note?
    var destination: String
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var data: FirestoreDb
    
    @State private var title = ""
    @State private var noteContent = ""
    @State var showAddNoteToFolder = false
    
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
        .navigationBarTitle(Text(note?.title ?? "New Note"), displayMode: .inline)
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $showAddNoteToFolder, content: {
            NavigationView {
                FolderPicker(note: note!,folders: data.folders, showPicker: $showAddNoteToFolder)
            }
        })
        .navigationBarItems(trailing:
            HStack(spacing: 20) {
                if (note != nil) {
                    Button(action: {
                            self.showAddNoteToFolder = true
                        }) {
                        Image(systemName: "note.text.badge.plus").resizable().frame(width: 26, height: 23).foregroundColor(Color.blue)
                            .font(Font.title.weight(.thin))
                        }
                }
                Button(action: {
                    if (note == nil) {
                        data.createNote(title: self.title, content: self.noteContent, destination: destination)
                    } else {
                        var noteUpdate = self.note
                        noteUpdate?.title = self.title
                        noteUpdate?.content = self.noteContent
                        data.updateNote(note: noteUpdate!)
                    }
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                    Image(systemName: "checkmark").resizable().frame(width: 26, height: 23).foregroundColor(Color.blue).font(Font.title.weight(.thin))
                    }
            })
    }
}
