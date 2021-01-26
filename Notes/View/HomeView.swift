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

struct Home : View {
    @EnvironmentObject var data: FirestoreDb
    
    var body : some View {
        NavigationView {
            if (data.notes.isEmpty) {
                VStack {
                    Spacer()
                    Indicator()
                    Spacer()
                }
                .navigationBarTitle(Text("Notes"), displayMode: .inline)
            }
            else {
                FoldersView()
            }
        }
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        .phoneOnlyStackNavigationView()
    }
}

// Enable lanscape mode
extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        }
        else {
            return AnyView(self)
        }
    }
}
