//
//  FoldersView.swift
//  Notes
//
//  Created by A friend on 1/16/21.
//  Copyright © 2021 Balaji. All rights reserved.
//

import SwiftUI
import Firebase

struct FoldersView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var data: FirestoreDb
    
    @State private var newFolder = ""
    @State private var editMode = EditMode.inactive
    @State private var showAddFolderError = false
    @State private var showDeleteConfirm = false
    @State var deleteFolderName = ""
    
    var body: some View {
        List {
            HStack {
                TextField("Create New Folder", text: $newFolder,
                    onCommit: {
                        if (!newFolder.isEmpty) {
                            if data.addFolder(folderName: newFolder) {
                                self.newFolder = ""
                                return
                            }
                        }
                        self.showAddFolderError = true
                    })
                .padding(10)
                .alert(isPresented: $showAddFolderError) {
                    Alert(title: Text("Folder exist or empty name"), dismissButton: .default(Text("Got it!")))
                }
                Spacer()
            }
            ForEach(data.getFolders(), id: \.self) { i in
                FoldersListElement(notes: data.getNotesInFolder(folderName: i), fName: i).deleteDisabled(i == "All")
            }
            .onMove(perform: moveRow)
            .onDelete(perform: deleteRow)
        }
        .environment(\.editMode, $editMode).animation(.default)
        .navigationBarTitle(Text("Notes"), displayMode: .inline)
        .alert(isPresented: $showDeleteConfirm) {
            Alert(title: Text("Are you sure you want to delete this?"), message: Text("There is no undo"),
                primaryButton: .destructive(Text("Delete")) {
                    data.removeFolder(folderName: deleteFolderName)
                    deleteFolderName = ""
                },
                secondaryButton: .cancel() {
                    self.showDeleteConfirm = false
                })
            }
        .navigationBarItems(leading:
                                Button(action: {
                                    let firebaseAuth = Auth.auth()
                                    do {
                                        try firebaseAuth.signOut()
                                    } catch let signOutError as NSError {
                                        print ("Error signing out: %@", signOutError)
                                    }
                                }) {
                                    Image(systemName: "person.circle").resizable().frame(width: 26, height: 26)
                                        .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
                                        .font(Font.title.weight(.thin))
                                }, trailing: PopActionMenu(editMode: $editMode))
    }
    private func deleteRow(at offsets: IndexSet) {
        self.deleteFolderName = data.folders[offsets.first!]
        self.showDeleteConfirm = true
    }
    
    private func moveRow(source: IndexSet, destination: Int) {
        data.folders.move(fromOffsets: source, toOffset: destination)
    }
}

