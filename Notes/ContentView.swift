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
                                
                                
                            }
                        }
                    }
                }
                
                
            }.edgesIgnoringSafeArea(.top)
            
            Button(action: {
                
                self.txt = ""
                self.docID = ""
                self.show.toggle()
                
            }) {
                
                Image(systemName: "plus").resizable().frame(width: 18, height: 18).foregroundColor(.white)
                
            }.padding()
            .background(Color.red)
            .clipShape(Circle())
            .padding()
        }
        .sheet(isPresented: self.$show) {
            
            EditView(txt: self.$txt, docID: self.$docID, show: self.$show)
        }
            
        .animation(.default)
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

struct MultiLineTF : UIViewRepresentable {
    
    
    func makeCoordinator() -> MultiLineTF.Coordinator {
        
        return MultiLineTF.Coordinator(parent1: self)
    }
    
    
    @Binding var txt : String
    
    func makeUIView(context: UIViewRepresentableContext<MultiLineTF>) -> UITextView{
        
        let view = UITextView()
        
        if self.txt != ""{
            
            view.text = self.txt
            view.textColor = .black
        }
        else{
            
            view.text = "Type Something"
            view.textColor = .gray
        }
        
        
        view.font = .systemFont(ofSize: 18)
        
        view.isEditable = true
        view.backgroundColor = .clear
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultiLineTF>) {
        
    }
    
    class Coordinator : NSObject,UITextViewDelegate{
        
        var parent : MultiLineTF
        
        init(parent1 : MultiLineTF) {
            
            parent = parent1
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            
            if self.parent.txt == ""{
                
                textView.text = ""
                textView.textColor = .black
            }

        }
        
        func textViewDidChange(_ textView: UITextView) {
            
            self.parent.txt = textView.text
        }
    }
}
