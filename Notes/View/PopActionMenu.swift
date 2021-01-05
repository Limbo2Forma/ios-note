//
//  PopActionMenu.swift
//  Notes
//
//  Created by A friend on 1/6/21.
//  Copyright © 2021 Balaji. All rights reserved.
//

import SwiftUI

struct PopActionMenu: View {
    
    @Binding var addFolder: Bool
    @Binding var editFolders: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 20) {
            if (!self.addFolder && !self.editFolders) {
                Menu {
                    Button(action: {
                            self.addFolder = true
                        }) {
                        HStack {
                            Image(systemName: "folder.badge.plus").resizable().frame(width: 25, height: 22)
                                .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black).font(Font.title.weight(.thin))
                            Text("Add folder")
                        }
                    }
                    Button(action: {
                            self.editFolders = true
                        }) {
                        HStack {
                            Image(systemName: "folder.badge.gear").resizable().frame(width: 25, height: 22)
                                .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black).font(Font.title.weight(.thin))
                            Text("Edit folders")
                        }
                    }
                } label: {
                    Image(systemName: "tray.full").resizable().frame(width: 26, height: 23)
                        .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black).font(Font.title.weight(.thin))
                }
            } else {
                Button(action: {
                        self.editFolders = false
                        self.addFolder = false
                    }) {
                    Image(systemName: "xmark").resizable().frame(width: 23, height: 23)
                        .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black).font(Font.title.weight(.thin))
                }
            }
            NavigationLink(destination: EditNoteView(note: nil, destination: "All")) {
                    Image(systemName: "plus").resizable().frame(width: 23, height: 23)
                        .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
                        .font(Font.title.weight(.thin))
            }
        }
    }
}

