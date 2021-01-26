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
import UIKit

// share the note by link

struct ShowSheet: View {
    var note: Note
    var folders: [String]
    @Binding var showPicker: Bool
    @Binding var isShareToSocialMedia: Bool
    @EnvironmentObject var data: FirestoreDb
    
    var body: some View {
        if self.isShareToSocialMedia {
            ActivityViewController(activityItems: data.getSharedDeepLink(note: note))
        } else {
            FolderPicker(note: note, folders: data.folders, showPicker: $showPicker)
        }
    }
}


struct ActivityViewController: UIViewControllerRepresentable {
    
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    //Creates the view controller object and configures its initial state
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    //Updates the state of the specified view controller with new information from SwiftUI.
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
    
}
