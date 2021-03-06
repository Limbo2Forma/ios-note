/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2020C
  Assessment: Final Project
  Author: Team 1 
  Created  date: 01/01/2020 
  Last modified: 26/01/2020
  Acknowledgement: Acknowledge the resources that you use here. 
*/

import SwiftUI
import Firebase

struct ListElement: View {
    // declare the variable 
    var note: Note
    var folderName: String
    
    @Environment(\.colorScheme) var colorScheme
    @State private var showDeleteConfirm = false
    @EnvironmentObject var data: FirestoreDb
    
    var body: some View {
        NavigationLink(destination: EditNoteView(note: note, destination: folderName)) {
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
