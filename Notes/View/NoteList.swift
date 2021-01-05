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
    @State var removeMode = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    ForEach(notes) { i in
                        NavigationLink(destination: EditNoteView(note: i, destination: title)) {
                            ListElement(note: i, folder: title, isRemovedMode: $removeMode)
                        }
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
        }
    }
}
