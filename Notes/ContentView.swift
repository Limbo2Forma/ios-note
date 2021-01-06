//
//  ContentView.swift
//  Notes
//
//  Created by Kavsoft on 29/02/20.
//  Copyright © 2020 Kavsoft. All rights reserved.
//

import SwiftUI
import Firebase

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct Home : View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var data: FirestoreDb
    
    @State private var newFolder = ""
    @State var editFolders = false
    @State var addFolder = false
    @State private var showAddFolderError = false
    
    var body : some View {
        NavigationView {
            if (data.notes.isEmpty) {
                VStack {
                    Spacer()
                    Indicator()
                    Spacer()
                }
                .navigationBarTitle(Text("Notes"), displayMode: .inline)
                .navigationBarItems(trailing: PopActionMenu(addFolder: self.$addFolder, editFolders: self.$editFolders))
            }
            else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing:0) {
                        if (self.addFolder) {
                            VStack {
                                Divider()
                                    .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
                                HStack {
                                    TextField("New Folder name", text: $newFolder,
                                        onCommit: {
                                            if data.addFolder(folderName: newFolder) {
                                                self.addFolder.toggle()
                                                self.newFolder = ""
                                            } else {
                                                self.showAddFolderError = true
                                            }
                                        }
                                    )
                                    .padding(10)
                                    .alert(isPresented: $showAddFolderError) {
                                                Alert(title: Text("Folder exist"), dismissButton: .default(Text("Got it!")))
                                            }
                                    Spacer()
                                }
                                .accentColor(self.colorScheme == .dark ? Color.white : Color.black)
                                Divider()
                                    .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
                            }
                            .background(Color.gray.opacity(0.3))
                        }
                        ForEach(data.getFolders(), id: \.self) { i in
                            FoldersListElement(notes: data.getNotesInFolder(folderName: i), fName: i, isEdit: self.$editFolders)
                        }
                    }
                }
                .navigationBarTitle(Text("Notes"), displayMode: .inline)
                .navigationBarItems(trailing: PopActionMenu(addFolder: self.$addFolder, editFolders: self.$editFolders))
            }
        }
    }
}
