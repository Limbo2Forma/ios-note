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
        //create the navigation bar in note field
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

