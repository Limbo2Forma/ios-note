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

struct PopActionMenu: View {
    
    @Binding var editMode: EditMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var data: FirestoreDb
    
    @State var showCreateNote = false
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: {
                if self.editMode == .active {
                    self.editMode = .inactive
                    data.rearrangeFolder(folders: data.folders)
                } else {
                    self.editMode = .active
                }
            }) {
                Image(systemName: editMode == EditMode.active ? "checkmark" : "tray.full" ).resizable().frame(width: editMode == EditMode.active ? 23 : 26, height: 23)
                    .foregroundColor(Color.blue).font(Font.title.weight(.thin))
            }
            Button(action: {
                self.showCreateNote.toggle()
            }) {
                Image(systemName: "plus").resizable().frame(width: 23, height: 23)
                    .foregroundColor(Color.blue)
                    .font(Font.title.weight(.thin))
                    .sheet(isPresented: $showCreateNote, content: {
                        NavigationView {
                            EditNoteView(note: nil, destination: "All")
                        }
                    })
            }
        }
    }
}

