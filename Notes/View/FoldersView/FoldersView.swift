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

struct FoldersView: View {
    // declare the variable 
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var data: FirestoreDb
    
    @State private var newFolder = ""
    @State private var editMode = EditMode.inactive
    @State private var showAddFolderError = false
    @State private var showDeleteConfirm = false
    @State var deleteFolderName = ""
    
    
    // the view and the controller when user create or use the folder in the app
    var body: some View {
        List {
            HStack {
                // create the new folder in MyNotes
                TextField("Create New Folder", text: $newFolder,
                          onCommit: {
                            if (!newFolder.isEmpty) {
                                if data.addFolder(folderName: newFolder) {
                                    self.newFolder = ""
                                    return
                                }
                            }
                            self.showAddFolderError = true
                          })
                    .padding(10)
                    // alert when title is empty or exist
                    .alert(isPresented: $showAddFolderError) {
                        Alert(title: Text("Folder exist or empty name"), dismissButton: .default(Text("Got it!")))
                    }
                Spacer()
            }
            ForEach(data.getFolders(), id: \.self) { i in
                FoldersListElement(notes: data.getNotesInFolder(folderName: i), fName: i).deleteDisabled(i == "All")
            }
            .onMove(perform: moveRow)
            .onDelete(perform: deleteRow)
        }
        // open the edit mode enviroment
        .environment(\.editMode, $editMode).animation(.default)
        .navigationBarTitle(Text("Notes"), displayMode: .inline)
        // pop-up warning when user whant to delete folder
        .alert(isPresented: $showDeleteConfirm) {
            Alert(title: Text("Are you sure you want to delete this?"), message: Text("There is no undo"),
                  primaryButton: .destructive(Text("Delete")) {
                    data.removeFolder(folderName: deleteFolderName)
                    deleteFolderName = ""
                  },
                  secondaryButton: .cancel() {
                    self.showDeleteConfirm = false
                  })
        }
        // navigation bar for folder
        .navigationBarItems(leading:
                                Button(action: {
                                    let firebaseAuth = Auth.auth()
                                    do {
                                        try firebaseAuth.signOut()
                                    } catch let signOutError as NSError {
                                        print ("Error signing out: %@", signOutError)
                                    }
                                }) {
                                    Image(systemName: "person.circle").resizable().frame(width: 26, height: 26)
                                        .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
                                        .font(Font.title.weight(.thin))
                                }, trailing: PopActionMenu(editMode: $editMode))
    }
    
    // delete folder
    private func deleteRow(at offsets: IndexSet) {
        self.deleteFolderName = data.folders[offsets.first!]
        self.showDeleteConfirm = true
    }
    // move folder
    private func moveRow(source: IndexSet, destination: Int) {
        data.folders.move(fromOffsets: source, toOffset: destination)
    }
}

