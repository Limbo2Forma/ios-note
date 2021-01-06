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
    
    @State private var viewState = CGSize(width: 0, height: screenHeight)
    @State private var MainviewState = CGSize.zero
    
    var body : some View {
        ZStack {
            CustomLoginViewController { (error) in
                if error == nil {
                    self.status()
                }
            }.offset(y: self.MainviewState.height).animation(.spring())
            Home().environmentObject(SessionStore()).offset(y: self.viewState.height).animation(.spring())
        }
    }
    
    func status() {
        self.viewState = CGSize(width: 0, height: 0)
        self.MainviewState = CGSize(width: 0, height: screenHeight)
    }
}

struct CustomLoginViewController : UIViewControllerRepresentable {
    
    var dismiss : (_ error : Error? ) -> Void
    
    func makeCoordinator() -> CustomLoginViewController.Coordinator {
        Coordinator(self)
    }
    
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
