//
//  NoteList.swift
//  Notes
//
//  Created by A friend on 1/3/21.
//  Copyright © 2021 Balaji. All rights reserved.
//

import SwiftUI

struct NoteList: View {

    var title: String
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var data: FirestoreDb
    
    @State var showCreateNote = false
    @State var deleteNote: Note? = nil
    @State var searchKeyword : String = ""
    @State var showAddNoteToFolder = false
    
    private var hasPinnedNote: Bool {
        return data.getNotesInFolder(folderName: title).contains {
            $0.pinned
        }
    }
    
    var body: some View {
        VStack {
            SearchBar(text: $searchKeyword)
            List {
                if hasPinnedNote {
                    Text("Pin Notes: ")
                    ForEach(data.getNotesInFolder(folderName: title).filter {
                        $0.pinned
                    }) { i in
                        ListElement(note: i, folderName: title)
                    }
                    .onDelete(perform: deleteRow)
                    
                    Color.gray
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                }
            
                if (title != "All") {
                    ForEach(data.getNotesInFolder(folderName: title).filter {
                        ( self.searchKeyword.isEmpty ? true : $0.title.lowercased().contains(self.searchKeyword.lowercased())) && !$0.pinned
                    }) { i in
                        ListElement(note: i, folderName: title)
                    }
                    .onDelete(perform: deleteRow)
                } else {
                    ForEach(data.getNotesInFolder(folderName: title).filter {
                        ( self.searchKeyword.isEmpty ? true : $0.title.lowercased().contains(self.searchKeyword.lowercased())) && !$0.pinned
                    }) { i in
                        ListElement(note: i, folderName: title)
                    }
                }
            }
            .sheet(isPresented: $showAddNoteToFolder, content: {
                NavigationView {
                    NotePicker(title: title,notes: data.notes, showPicker: $showAddNoteToFolder)
                }
            })
            .navigationBarTitle(Text(title), displayMode: .inline)
            .navigationBarItems(trailing:
                HStack(spacing: 20) {
                    if (title != "All") {
                        Button(action: {
                            self.showAddNoteToFolder = true
                            }) {
                            Image(systemName: "note.text.badge.plus").resizable().frame(width: 26, height: 23).foregroundColor(Color.blue)
                                .font(Font.title.weight(.thin))
                            }
                    }
                    Button(action: {
                        self.showCreateNote.toggle()
                    }) {
                        Image(systemName: "plus").resizable().frame(width: 23, height: 23)
                            .foregroundColor(Color.blue)
                            .font(Font.title.weight(.thin))
                            .sheet(isPresented: $showCreateNote, content: {
                                NavigationView {
                                    EditNoteView(note: nil, destination: title)
                                }
                            })
                    }
                })
        }
    }
    
    private func deleteRow(at offsets: IndexSet) {
        self.deleteNote = data.getNotesInFolder(folderName: title)[offsets.first!]
        if (title != "All") {
            data.removeNoteInFolder(note: deleteNote!, folderName: title)
        } else {
            data.deleteNote(note: deleteNote!)
        }
        
        deleteNote = nil
    }
}
