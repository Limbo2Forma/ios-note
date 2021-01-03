//
//  firebaseAuth.swift
//  Notes
//
//  Created by A friend on 1/3/21.
//  Copyright © 2021 Balaji. All rights reserved.
//

import SwiftUI
import Firebase

class getCurrentUser : ObservableObject{
    
    @Published var uuid=""
    @Published var notSignedIn = false
    
    init() {
        
        let fbAuth = Auth.auth()
        
        fbAuth.addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.uuid = user.uid
            }
        }
    }
}
