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
    var note: Note;
    @Binding var isRemovedMode: Bool
    
    var body: some View {
        NavigationLink(destination: EditNoteView(note: note)) {
            HStack(spacing: 15){
                VStack(alignment: .leading, spacing: 12){
                    Text(note.title)
                    Text(note.content).lineLimit(1)
                    Text(note.date).lineLimit(1)
                    Divider()
                }.padding(10)
                .foregroundColor(.black)
                
                if isRemovedMode {
                    Button(action: {
                        let db = Firestore.firestore()
                        db.collection("notes").document(note.id).delete()

                    }) {
                        Image(systemName: "minus.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.red)
                    }
                }

            }.padding(.horizontal)
        }
    }
}
