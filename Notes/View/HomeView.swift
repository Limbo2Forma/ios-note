//
//  ContentView.swift
//  Notes
//
//  Created by Kavsoft on 29/02/20.
//  Copyright © 2020 Kavsoft. All rights reserved.
//

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
