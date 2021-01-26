//
//  FolderPicker.swift
//  Notes
//
//  Created by A friend on 1/16/21.
//  Copyright © 2021 Balaji. All rights reserved.
//

import SwiftUI

struct NotePicker: View {
    var title: String
    var notes: [Note]
    @Binding var showPicker: Bool
    @EnvironmentObject var data: FirestoreDb
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        List {
            ForEach(notes.filter{ n in
                return !n.folders.contains(title)
            }) { note in
                Button(action: {
                    data.addNoteInFolder(note: note, folderName: title)
                    self.showPicker = false
                }, label: {
                    HStack(spacing: 10) {
                        Image(systemName: "doc.richtext")
                        .resizable()
                        .frame(width: 24, height: 20)
                        .font(Font.title.weight(.thin))
                        VStack(alignment: .leading) {
                            HStack {
                                Text(note.title).fontWeight(.bold).accentColor(self.colorScheme == .dark ? Color.white : Color.black).font(.system(size: 30)).padding(.horizontal, 10).padding(.top, 5).lineLimit(1)
                                Spacer()
                            }
                            HStack {
                                Text(note.date).lineLimit(1).accentColor(self.colorScheme == .dark ? Color.white : Color.black).padding(.horizontal, 10).padding(.bottom, 5)
                                Spacer()
                            }
                            .accentColor(self.colorScheme == .dark ? Color.white : Color.black)
                        }
                    }
                })
            }
        }
        .navigationBarTitle(Text("Add to " + title), displayMode: .inline)
        .navigationBarItems(trailing:
                                Button(action: {
                                    self.showPicker = false
                                    }) {
                                    Image(systemName: "xmark").resizable().frame(width: 23, height: 23).foregroundColor(Color.blue).font(Font.title.weight(.thin))
                                    }
        )
    }
}

