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
                                
                                HStack(spacing: 15){
                                    
                                    Button(action: {
                                        
                                        self.docID = i.id
                                        self.txt = i.note
                                        
                                        self.show.toggle()
                                        
                                    }) {
                                        
                                        VStack(alignment: .leading, spacing: 12){
                                            
                                            Text(i.date)
                                            
                                            Text(i.note).lineLimit(1)
                                            
                                            Divider()
                                            
                                        }.padding(10)
                                        .foregroundColor(.black)
                                    }
                                    
                                    if self.remove{
                                        
                                        Button(action: {
                                            
                                            let db = Firestore.firestore()
                                            
                                            db.collection("notes").document(i.id).delete()
                                            
                                        }) {
                                            
                                            Image(systemName: "minus.circle.fill")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.red)
                                        }
                                    }
 
                                }.padding(.horizontal)
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

class getNotes : ObservableObject{
    
    @Published var data = [Note]()
    @Published var noData = false
    
    init() {
        
        let db = Firestore.firestore()
        
        db.collection("notes").order(by: "date", descending: false).addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                self.noData = true
                return
            }
            
            if (snap?.documentChanges.isEmpty)!{
                
                self.noData = true
                return
            }
            
            for i in snap!.documentChanges{
                
                if i.type == .added{
                    
                    let id = i.document.documentID
                    
                    let notes = i.document.get("notes") as! String
                    
                    let date = i.document.get("date") as! Timestamp
                    
                    let format = DateFormatter()
                    
                    format.dateFormat = "dd-MM-YY hh:mm a"
                    
                    let dateString = format.string(from: date.dateValue())
                    
                    self.data.append(Note(id: id, note: notes, date: dateString))
                }
                
                if i.type == .modified{
                    
                    // when data is changed...
                    
                    let id = i.document.documentID
                       
                    let notes = i.document.get("notes") as! String
                    
                    for i in 0..<self.data.count{
                        
                        if self.data[i].id == id{
                            
                            self.data[i].note = notes
                        }
                    }
                }
                
                if i.type == .removed{
                    
                    // when data is removed...
                    
                    let id = i.document.documentID
                    
                    for i in 0..<self.data.count{
                        
                        if self.data[i].id == id{
                            
                            self.data.remove(at: i)
                            
                            if self.data.isEmpty{
                                
                                self.noData = true
                            }
                            
                            return
                        }
                    }
                }
            }
        }
    }
}

struct Note : Identifiable {
    
    var id : String
    var note : String
    var date : String
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

struct EditView : View {
    
    @Binding var txt : String
    @Binding var docID : String
    @Binding var show : Bool
    
    var body : some View{
        
        ZStack(alignment: .bottomTrailing) {
            
            MultiLineTF(txt: self.$txt)
                .padding()
                .background(Color.black.opacity(0.05))
            
            Button(action: {
                
                self.show.toggle()
                self.SaveData()
                
                
            }) {
                
                Text("Save").padding(.vertical).padding(.horizontal,25).foregroundColor(.white)
                
            }.background(Color.red)
            .clipShape(Capsule())
            .padding()
            
        }.edgesIgnoringSafeArea(.bottom)
    }
    
    
    func SaveData(){
        
        let db = Firestore.firestore()
        
        if self.docID != ""{
            
            db.collection("notes").document(self.docID).updateData(["notes":self.txt]) { (err) in
                
                if err != nil{
                    
                    print((err?.localizedDescription)!)
                    return
                }
            }
        }
        
        else{
            
            db.collection("notes").document().setData(["notes":self.txt,"date":Date()]) { (err) in
                
                if err != nil{
                    
                    print((err?.localizedDescription)!)
                    return
                }
            }
        }
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
