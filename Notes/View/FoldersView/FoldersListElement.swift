//
//  FoldersListElement.swift
//  Notes
//
//  Created by A friend on 1/4/21.
//  Copyright © 2021 Balaji. All rights reserved.
//

import SwiftUI

struct FoldersListElement: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var data: FirestoreDb
    
    @State private var folderNameEdited: String
    @State private var showDuplicateAlert = false
    @State private var onTextEdit = false
    
    var notes = [Note]()
    var folderName: String
    
    init(notes: [Note], fName: String) {
        self.notes = notes
        self.folderName = fName
        self._folderNameEdited = State(wrappedValue: fName)
    }
    
    var body: some View {
        if (!onTextEdit || folderName == "All") {
            NavigationLink(destination: NoteList(title: folderName)) {
                HStack(spacing: 10) {
                    Image(systemName: "folder")
                    .resizable()
                    .frame(width: 24, height: 20)
                    .font(Font.title.weight(.thin))
                    Text(folderName).padding(10)
                }
                .onLongPressGesture {
                    self.onTextEdit = true
                }
            }
        } else {
            HStack {
                Image(systemName: "folder")
                .resizable()
                .frame(width: 24, height: 20)
                .font(Font.title.weight(.thin))
                TextField("Folder Name",
                          text: $folderNameEdited,
                          onCommit: {
                            self.showDuplicateAlert =  data.renameFolder(oldName: folderName, newName: folderNameEdited)
                            self.onTextEdit = false
                          }
                )
                .padding(10)
                .alert(isPresented: $showDuplicateAlert) {
                    Alert(title: Text("Folder exist"), dismissButton: .default(Text("Got it!")))
                    }
                Spacer()
            }
        }
    }
}

