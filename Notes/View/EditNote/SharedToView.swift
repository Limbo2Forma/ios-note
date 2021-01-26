import SwiftUI
import UIKit

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
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
    
}
