//
//  ContentView.swift
//  Notes
//
//  Created by Kavsoft on 29/02/20.
//  Copyright © 2020 Kavsoft. All rights reserved.
//

import SwiftUI
import Firebase

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    
    @ObservedObject var Notes = getNotes()
    @State var show = false
    @State var txt = ""
    @State var docID = ""
    @State var remove = false
    
    var body : some View{
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                
                VStack(spacing: 0){
                    
                    HStack{
                        Text("Notes").font(.title).foregroundColor(.white)
                        Spacer()
                        Button(action: {
                            self.remove.toggle()
                        }) {
                            
                            Image(systemName: self.remove ? "xmark.circle" : "trash").resizable().frame(width: 23, height: 23).foregroundColor(.white)
                        }
                        
                    }.padding()
                    .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
                    .background(Color.red)
                    
                    if self.Notes.data.isEmpty{
                        if self.Notes.noData{
                            Spacer()
                            Text("No Notes !!!")
                            Spacer()
                        }
                        else{
                            Spacer()
                            //Data is Loading ....
                            Indicator()
                            Spacer()
                        }
                    }
                    else{
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack{
                                ForEach(self.Notes.data){i in
                                    ListElement(note: i, isRemovedMode: self.$remove)
                                }
                            }
                        }
                    }
                }.edgesIgnoringSafeArea(.top)
                NavigationLink(destination: EditNoteView(note: nil)) {
                    Image(systemName: "plus").resizable().frame(width: 18, height: 18).foregroundColor(.white).padding()
                        .background(Color.red)
                        .clipShape(Circle())
                        .padding()
                }
            }
            .animation(.default)
        }
    }
}

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}

class Host : UIHostingController<ContentView>{
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        
        return .lightContent
    }
}

struct Indicator : UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<Indicator>) -> UIActivityIndicatorView {
        
        let view = UIActivityIndicatorView(style: .medium)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Indicator>) {
    }
}
