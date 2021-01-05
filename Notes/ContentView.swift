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
            ZStack(alignment: .bottomTrailing) {
                if (data.notes.isEmpty) {
                    VStack {
                        if (data.noData) {
                            Spacer()
                            Text("No Notes !!!")
                            Spacer()
                        }
                        else{
                            Spacer()
                            Indicator()
                            Spacer()
                        }
                    }
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
                }
                NavigationLink(destination: EditNoteView(note: nil, destination: "All")) {
                    Image(systemName: "plus").resizable().frame(width: 20, height: 20).foregroundColor(.white).padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                        .padding(15)
                }
            }
            .navigationBarTitle(Text("Notes"), displayMode: .inline)
            .navigationBarItems(trailing:
                                    HStack(spacing: 20) {
                                        Button(action: {
                                        self.addFolder.toggle()
                                            }) {
                                            if self.addFolder {
                                                Image(systemName: "xmark").resizable().frame(width: 23, height: 23)
                                                    .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
                                            } else {
                                                Image(systemName: "folder.badge.plus").resizable().frame(width: 25, height: 20)
                                                    .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
                                            }
                                        }
                                            
                                        Button(action: {
                                        self.editFolders.toggle()
                                            }) {
                                            if self.editFolders {
                                                Image(systemName: "xmark").resizable().frame(width: 23, height: 23)
                                                    .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
                                            } else {
                                                Image(systemName: "tray.full").resizable().frame(width: 25, height: 20)
                                                    .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
                                            }
                                        }
                                    }
                )
        }
    }
}
