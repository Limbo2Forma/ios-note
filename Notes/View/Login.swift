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
import FirebaseUI
import Firebase

public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

struct Login : View {
    @State var viewState = CGSize(width: 0, height: screenHeight)
    @State private var MainviewState = CGSize.zero
    @EnvironmentObject var data: FirestoreDb
    
    var body : some View {
        if data.currentUser != nil {
            Home().onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
        else {
            CustomLoginViewController { (error) in
                if error == nil {
                    self.status()
                }
            }.offset(y: self.MainviewState.height).animation(.spring())
        }
    }
    
    func status() {
        self.viewState = CGSize(width: 0, height: 0)
        self.MainviewState = CGSize(width: 0, height: screenHeight)
    }
}

// Use a UIViewControllerRepresentable instance to create and manage a UIViewController object in your SwiftUI interface
struct CustomLoginViewController : UIViewControllerRepresentable {
    
    var dismiss : (_ error : Error? ) -> Void
    //Creates the custom instance that you use to communicate changes from your view controller to other parts of your SwiftUI interface.
    func makeCoordinator() -> CustomLoginViewController.Coordinator {
        Coordinator(self)
    }
    //Creates the view controller object and configures its initial state
    func makeUIViewController(context: Context) -> UIViewController
    {
        let authUI = FUIAuth.defaultAuthUI()
        
        let providers : [FUIAuthProvider] = [
            FUIEmailAuth(),
            FUIFacebookAuth(),
        ]

        authUI?.providers = providers
        authUI?.delegate = context.coordinator
        
        let authViewController = authUI?.authViewController()

        return authViewController!
    }
    //Updates the state of the specified view controller with new information from SwiftUI.
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CustomLoginViewController>)
    {
        
    }
    
    //coordinator
    class Coordinator : NSObject, FUIAuthDelegate {
        var parent : CustomLoginViewController
        
        init(_ customLoginViewController : CustomLoginViewController) {
            self.parent = customLoginViewController
        }
        
        // MARK: FUIAuthDelegate
        func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?)
        {
            if let error = error {
                parent.dismiss(error)
            }
            else {
                parent.dismiss(nil)
            }
        }
        
        func authUI(_ authUI: FUIAuth, didFinish operation: FUIAccountSettingsOperationType, error: Error?)
        {
        }
    }
}
