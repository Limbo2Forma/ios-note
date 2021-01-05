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
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    ForEach(notes) { i in
                        NavigationLink(destination: EditNoteView(note: i, destination: title)) {
                            ListElement(note: i, isRemovedMode: $removeMode)
                        }
                    }
                }
            }
            .navigationBarTitle(Text(title), displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                self.removeMode.toggle()
                    }) {
                    Image(systemName: self.removeMode ? "xmark.circle" : "trash").resizable().frame(width: 23, height: 23).foregroundColor(.white)
                    }
                )
            NavigationLink(destination: EditNoteView(note: nil, destination: title)) {
                Image(systemName: "plus").resizable().frame(width: 19, height: 19).foregroundColor(.white).padding()
                    .background(Color.blue)
                    .clipShape(Circle())
                    .padding(15)
            }
        }
    }
}
