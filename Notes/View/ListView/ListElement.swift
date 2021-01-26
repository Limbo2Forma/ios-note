//
//  ListElement.swift
//  Notes
//
//  Created by A friend on 1/2/21.
//  Copyright © 2021 Balaji. All rights reserved.
//

import SwiftUI
import Firebase

struct ListElement: View {
    var note: Note
    var folderName: String
    
    @Environment(\.colorScheme) var colorScheme
    @State private var showDeleteConfirm = false
    @EnvironmentObject var data: FirestoreDb
    
    var body: some View {
        NavigationLink(destination: EditNoteView(note: note, destination: folderName), tag: note.id, selection: $data.redirectedId) {
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
                Spacer()
                Button(action: {
                    data.pinNote(note: note)
                }) {
                    Image(systemName: note.pinned ? "pin.fill" : "pin").resizable().frame(width: 18, height: 23)
                        .foregroundColor(Color.blue)
                        .font(Font.title.weight(.thin))
                        .rotationEffect(Angle(degrees: 90))
                }.buttonStyle(PlainButtonStyle())
            }
        }
    }
}
