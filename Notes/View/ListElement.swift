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
    var folder: String
    
    @Binding var isRemovedMode: Bool
    @Environment(\.colorScheme) var colorScheme
    @State private var showDeleteConfirm = false
    @EnvironmentObject var data: FirestoreDb
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading){
                Divider()
                    .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
                HStack {
                    Text(note.title).fontWeight(.bold).accentColor(self.colorScheme == .dark ? Color.white : Color.black).font(.system(size: 30)).padding(.horizontal, 10).padding(.top, 5)
                    Spacer()
                }
                HStack {
                    Text(note.date).lineLimit(1).accentColor(self.colorScheme == .dark ? Color.white : Color.black).padding(.horizontal, 10).padding(.bottom, 5)
                    Spacer()
                }
                .accentColor(self.colorScheme == .dark ? Color.white : Color.black)
                Divider()
                    .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
            }
            
            if isRemovedMode {
                Button(action: {
                    let db = Firestore.firestore()
                    db.collection("notes").document(note.id).delete()

                }) {
                    Image(systemName: "minus.circle")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .foregroundColor(.red)
                }
            }
        }
        .padding(.trailing, 10)
        .background(Color.gray.opacity(0.3))
        .alert(isPresented: $showDeleteConfirm) {
            Alert(title: Text("Are you sure you want to remove this note from the folder?"), message: Text("The note still exist in other folders"),
                primaryButton: .destructive(Text("Remove")) {
                    data.removeNoteInFolder(note: note, folderName: folder)
                },
                secondaryButton: .cancel())
            }
    }
}
