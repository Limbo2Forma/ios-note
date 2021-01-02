//
//  firebaseFunction.swift
//  Notes
//
//  Created by A friend on 1/2/21.
//  Copyright © 2021 Balaji. All rights reserved.
//

import SwiftUI
import Firebase

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
                print(i.document.data())
                if i.type == .added{
                    
                    let id = i.document.documentID
                    let title = i.document.get("title") as! String
                    let location = i.document.get("location") as! String
                    let content = i.document.get("content") as! String
                    let date = i.document.get("date") as! Timestamp
                    let ownerId = i.document.get("ownerId") as! String
                    
                    let format = DateFormatter()
                    format.dateFormat = "dd-MM-YY hh:mm a"
                    let dateString = format.string(from: date.dateValue())
                    
                    self.data.append(Note(id: id, ownerId: ownerId, title: title, location: location, content: content, date:dateString))
                }
                
                if i.type == .modified{
                    
                    // when data is changed...
                    
                    let id = i.document.documentID
                    let title = i.document.get("title") as! String
                    let location = i.document.get("location") as! String
                    let content = i.document.get("content") as! String
                    
                    for i in 0..<self.data.count{
                        if self.data[i].id == id{
                            self.data[i].title = title
                            self.data[i].location = location
                            self.data[i].content = content
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

func SaveData(note: Note){
    
    let db = Firestore.firestore()
    
    if note.id != ""{
        db.collection("notes").document(note.id).updateData([
            "ownerId": note.ownerId,
            "title": note.title,
            "location": note.location,
            "content": note.content,
            "date": note.date
        ]) { (err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
        }
    }
    
    else{
        db.collection("notes").document().setData([
            "ownerId": note.ownerId,
            "title": note.title,
            "location": note.location,
            "content": note.content,
            "date": note.date
        ]) { (err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
        }
    }
}
