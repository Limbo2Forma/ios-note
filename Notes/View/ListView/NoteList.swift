//
//  NoteList.swift
//  Notes
//
//  Created by A friend on 1/3/21.
//  Copyright © 2021 Balaji. All rights reserved.
//

import SwiftUI

struct NoteList: View {
    var notes: [Note]
    var title: String
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var data: FirestoreDb
    @State var removeMode = false
    @State private var showDeleteConfirm = false
    @State var deleteNote: Note? = nil
    
    var body: some View {
        List {
            if (title != "All") {
                ForEach(notes) { i in
                    ListElement(note: i, folderName: title, isRemovedMode: $removeMode)
                }
                .onDelete(perform: deleteRow)
            } else {
                ForEach(notes) { i in
                    ListElement(note: i, folderName: title, isRemovedMode: $removeMode)
                }
            }
            
        }
        .navigationBarTitle(Text(title), displayMode: .inline)
        .navigationBarItems(trailing:
            HStack(spacing: 20) {
                if (title != "All") {
                    Button(action: {
                    self.removeMode.toggle()
                        }) {
                        Image(systemName: self.removeMode ? "xmark" : "tray.full").resizable().frame(width: self.removeMode ? 23 : 26, height: 23).foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
                            .font(Font.title.weight(.thin))
                        }
                }
                NavigationLink(destination: EditNoteView(note: nil, destination: title)) {
                        Image(systemName: "plus").resizable().frame(width: 23, height: 23)
                            .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
                            .font(Font.title.weight(.thin))
                }
            })
        .alert(isPresented: $showDeleteConfirm) {
            Alert(title: Text("Are you sure you want to delete this?"), message: Text("The note still exist, but not in this folder"),
                primaryButton: .destructive(Text("Delete")) {
                    data.removeNoteInFolder(note: deleteNote!, folderName: title)
                    deleteNote = nil
                },
                secondaryButton: .cancel() {
                    self.showDeleteConfirm = false
                })
            }
    }
    
    private func deleteRow(at offsets: IndexSet) {
        self.deleteNote = notes[offsets.first!]
        self.showDeleteConfirm = true
    }
}
