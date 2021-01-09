//
//  ContentView.swift
//  Notes
//
//  Created by Kavsoft on 29/02/20.
//  Copyright © 2020 Kavsoft. All rights reserved.
//

import SwiftUI
import Firebase

struct Home : View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var data: FirestoreDb
    
    @State private var newFolder = ""
    @State private var editMode = EditMode.inactive
    @State private var showAddFolderError = false
    @State private var showDeleteConfirm = false
    
    @State var deleteFolderName = ""
    
    var body : some View {
        NavigationView {
            if (data.notes.isEmpty) {
                VStack {
                    Spacer()
                    Indicator()
                    Spacer()
                }
                .navigationBarTitle(Text("Notes"), displayMode: .inline)
            }
            else {
                List {
                    HStack {
                        TextField("Create New Folder", text: $newFolder,
                            onCommit: {
                                if data.addFolder(folderName: newFolder) {
                                    self.newFolder = ""
                                } else {
                                    self.showAddFolderError = true
                                }
                            })
                        .padding(10)
                        .alert(isPresented: $showAddFolderError) {
                            Alert(title: Text("Folder exist"), dismissButton: .default(Text("Got it!")))
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
                .navigationBarItems(trailing: PopActionMenu(editMode: $editMode))
            }
        }
        .onAppear(perform: getData)
    }
    
    func getData() {
        data.listen()
    }
    
    private func deleteRow(at offsets: IndexSet) {
        self.deleteFolderName = data.folders[offsets.first!]
        self.showDeleteConfirm = true
    }
    
    private func moveRow(source: IndexSet, destination: Int) {
        data.folders.move(fromOffsets: source, toOffset: destination)
    }
}
