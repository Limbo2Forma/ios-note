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

struct FolderPicker: View {
    var note: Note
    var folders: [String]
    @Binding var showPicker: Bool
    @EnvironmentObject var data: FirestoreDb
    
    var body: some View {
        List {
            ForEach(folders.filter{ n in
                return !note.folders.contains(n)
            }, id: \.self) { i in
                Button(action: {
                    data.addNoteInFolder(note: note, folderName: i)
                    self.showPicker = false
                }, label: {
                    HStack(spacing: 10) {
                        Image(systemName: "folder")
                        .resizable()
                        .frame(width: 24, height: 20)
                        .font(Font.title.weight(.thin))
                        Text(i).padding(10)
                    }
                })
            }
        }
        // create the navigation bar 
        .navigationBarTitle(Text("Add to folder"), displayMode: .inline)
        .navigationBarItems(trailing:
                                Button(action: {
                                    self.showPicker = false
                                    }) {
                                    Image(systemName: "xmark").resizable().frame(width: 23, height: 23).foregroundColor(Color.blue).font(Font.title.weight(.thin))
                                    }
        )
    }
}

