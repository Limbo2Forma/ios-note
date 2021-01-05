//
//  FoldersListElement.swift
//  Notes
//
//  Created by A friend on 1/4/21.
//  Copyright © 2021 Balaji. All rights reserved.
//

import SwiftUI

struct FoldersListElement: View {
    
    @Binding var isEdit: Bool
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var data: FirestoreDb
    
    @State private var folderNameEdited: String
    @State private var showDeleteConfirm = false
    @State private var showDuplicateAlert = false
    
    var notes = [Note]()
    var folderName: String
    
    init(notes: [Note], fName: String, isEdit: Binding<Bool>) {
        self.notes = notes
        self.folderName = fName
        self._folderNameEdited = State(wrappedValue: fName)
        self._isEdit = isEdit
    }
    
    var body: some View {
        if (!isEdit || folderName == "All") {
            NavigationLink(destination: NoteList(notes: notes, title: folderName)) {
                VStack {
                    Divider()
                        .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
                    HStack {
                        Text(folderName).padding(10)
                        Spacer()
                    }
                    .accentColor(self.colorScheme == .dark ? Color.white : Color.black)
                    Divider()
                        .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
                }
                .background(Color.gray.opacity(0.3))
            }
        } else {
            VStack {
                Divider()
                    .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
                HStack {
                    TextField("Folder Name",
                              text: $folderNameEdited,
                              onCommit: {
                                self.showDuplicateAlert =  data.renameFolder(oldName: folderName, newName: folderNameEdited)
                              }
                    )
                    .padding(10)
                    .alert(isPresented: $showDuplicateAlert) {
                        Alert(title: Text("Folder exist"), dismissButton: .default(Text("Got it!")))
                        }
                    Spacer()
                    if isEdit {
                        Button(action: {
                            self.showDeleteConfirm.toggle()
                        }) {
                            Image(systemName: "trash")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.red)
                        }
                    }
                }
                .accentColor(self.colorScheme == .dark ? Color.white : Color.black)
                Divider()
                    .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
            }
            .padding(.trailing, 10)
            .background(Color.gray.opacity(0.3))
            .alert(isPresented: $showDeleteConfirm) {
                Alert(title: Text("Are you sure you want to delete this?"), message: Text("There is no undo"),
                    primaryButton: .destructive(Text("Delete")) {
                        data.removeFolder(folderName: folderName)
                    },
                    secondaryButton: .cancel())
                }
        }
    }
}

