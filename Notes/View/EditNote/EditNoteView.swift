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
    
    @State var showSheet = false
    @State var isShareToSocialMedia = false
    
    var body : some View {
        VStack() {
            TextField("Note Title", text: $title)
                .padding(10)
                .font(.title)
            Divider()
            TextEditorView(initContent: note?.content ?? "", noteContent: $noteContent)
        }
        .onAppear {
            self.title = note?.title ?? ""
            data.resetRedirect()
        }
// create the new note
        .navigationBarTitle(Text(note?.title ?? "New Note"), displayMode: .inline) // title navigation bar
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $showSheet, content: {
            ShowSheet(note: note!, folders: data.folders, showPicker: $showSheet, isShareToSocialMedia: $isShareToSocialMedia)
        })
        .onDisappear(perform: {
            if var noteUpdate = self.note {
                noteUpdate.title = self.title == "" ? noteUpdate.title : self.title
                noteUpdate.content = self.noteContent
                data.updateNote(note: noteUpdate)
            } else {
                data.createNote(title: self.title == "" ? "new note" : self.title, content: self.noteContent, destination: destination)
            }
        })
        .navigationBarItems(trailing:
            HStack(spacing: 20) {
                if (note != nil) {
                    Button(action: {
                        self.showSheet = true
                        self.isShareToSocialMedia = false
                    }) {
                        Image(systemName: "note.text.badge.plus")
                            .resizable().frame(width: 26, height: 23).foregroundColor(Color.blue)
                                .font(Font.title.weight(.thin))
                    }
                    Button(action: {
                        self.showSheet.toggle()
                        self.isShareToSocialMedia = true
                    }) {
                    // create the button for share the note in social media such as facebook, whatApps, ...
                        Image(systemName: "square.and.arrow.up.on.square.fill")
                            .resizable().frame(width: 23, height: 23).foregroundColor(Color.blue)
                                .font(Font.title.weight(.thin))
                    }
                }
            })
    }
}
