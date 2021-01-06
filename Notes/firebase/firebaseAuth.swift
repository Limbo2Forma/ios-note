import SwiftUI
import Firebase
import Combine

class SessionStore : ObservableObject {
    var didChange = PassthroughSubject<SessionStore, Never>()
    var sessionId: String? { didSet { self.didChange.send(self) }}
    var handle: AuthStateDidChangeListenerHandle?
    
    let db = Firestore.firestore().collection("users")
    
    func listen () {
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // if we have a user, create a new user model
                print("Got user: \(user)")
                self.sessionId = user.uid
                
                self.db.document(user.uid).getDocument { (document, error) in
                    if let document = document, !document.exists {
                        self.db.document(user.uid).setData([
                            "email": user.email!,
                            "folders": []]
                        )
                    }
                }
            } else {
                // if we don't have a user, set our session to nil
                self.sessionId = nil
            }
        }
    }

    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) {
            authResult, error in
                if let userRes = authResult?.user {
                    self.db.document(userRes.uid).setData([
                        "email": userRes.email!,
                        "folders": []]
                    )
                }
        }
    }
    
    func signIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func signOut () -> Bool {
        do {
            try Auth.auth().signOut()
            self.sessionId = nil
            return true
        } catch {
            return false
        }
    }
    
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
