//
//  firebaseFunction.swift
//  Notes
//
//  Created by A friend on 1/2/21.
//  Copyright © 2021 Balaji. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

class FirestoreDb : ObservableObject {
    
    @Published var notes = [Note]()
    @Published var noData = false
    @Published var folders = [String]()
    
//    var uuid = "wfR97S1gZ8f22Kt4VLTt3bfhaQ83"
    var db: DocumentReference
    let format = DateFormatter()
    
    init(user: User) {
        self.db = Firestore.firestore().collection("users").document(user.uid)
        
        self.db.getDocument { (document, error) in
            if let document = document, !document.exists {
                self.db.setData([
                    "email": user.email ?? "none",
                    "folders": ["All"]
                ])
            }
        }
        
        self.db.collection("notes").order(by: "date", descending: false).addSnapshotListener { (snap, err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                self.noData = true
                return
            }
            
            if (snap?.documentChanges.isEmpty)! {
                self.noData = true
                return
            }
            
            for i in snap!.documentChanges {
                if i.type == .added {
                    
                    let id = i.document.documentID
                    let title = i.document.get("title") as! String
                    let folders = i.document.get("folders") as! [String]
                    let content = i.document.get("content") as! String
                    let date = i.document.get("date") as! Timestamp
                    
                    self.format.dateFormat = "dd-MM-YY hh:mm a"
                    let dateString = self.format.string(from: date.dateValue())
                    
                    let newNote = Note(id: id, title: title, folders: folders, content: content, date:dateString)
                    self.notes.append(newNote)
                }
                
                if i.type == .modified {
                    let id = i.document.documentID
                    let title = i.document.get("title") as! String
                    let folders = i.document.get("folder") as! [String]
                    let content = i.document.get("content") as! String
                    
                    for i in 0..<self.notes.count {
                        if self.notes[i].id == id {
                            self.notes[i].title = title
                            self.notes[i].folders = folders
                            self.notes[i].content = content
                        }
                    }
                }
                
                if i.type == .removed{
                    let id = i.document.documentID
                    
                    for i in 0..<self.notes.count {
                        if self.notes[i].id == id {
                            self.notes.remove(at: i)
                            if self.notes.isEmpty{
                                self.noData = true
                            }
                            return
                        }
                    }
                }
            }
            print(self.notes)
        }
        
        self.db.addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                let fd = document.get("folders")
                if fd != nil {
                    self.folders = fd as! [String]
                }
                print(self.notes)
            }
    }
    
    func getFolders() -> [String] {
        return folders
    }
    
    func getNotes() -> [Note] {
        return notes
    }
    
    func isNoData() -> Bool {
        return noData
    }
    
    func getNotesInFolder(folderName: String) -> [Note] {
        return notes.filter { n in
            return n.folders.contains(folderName)
        }
    }
    
    func addFolder(folderName: String) -> Bool {
        if self.folders.contains(folderName) {
            return false
        }
        self.folders.append(folderName)
        self.db.updateData([
            "folders": folders
        ]) { (err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
        }
        return true
    }
    
    func removeFolder(folderName: String) {
        let batch = Firestore.firestore().batch()
        
        for i in self.notes {
            if i.folders.contains(folderName) {
                batch.updateData([
                    "folders": i.folders.filter{ n in n != folderName }
                ], forDocument: db.collection("notes").document(i.id))
            }
        }
        
        batch.updateData([
            "folders": self.folders.filter{ n in n != folderName }
        ], forDocument: db)
        
        batch.commit() { (err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
        }
    }
    
    func renameFolder(oldName: String, newName: String) -> Bool {
        if self.folders.contains(newName) {
            return true
        }
        
        let batch = Firestore.firestore().batch()
        
        for i in self.notes {
            if let index = i.folders.firstIndex(of: oldName) {
                var newFolders = i.folders
                newFolders[index] = newName
                
                batch.updateData([
                    "folders": newFolders
                ], forDocument: db.collection("notes").document(i.id))
            }
        }
        
        if let index = self.folders.firstIndex(of: oldName) {
            var newFolders = self.folders
            newFolders[index] = newName
            
            batch.updateData([
                "folders": newFolders
            ], forDocument: db)
        }
        
        batch.commit() { (err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
        }
        return false
    }
    
    func addNoteInFolder(note: Note, folderName: String) -> Bool{
        if note.folders.contains(folderName) {
            return false
        }
        var noteph = note
        noteph.folders.append(folderName)
        
        self.db.collection("notes").document(note.id).updateData([
            "folders": noteph
        ]) { (err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
        }
        return true
    }
    
    func removeNoteInFolder(note: Note, folderName: String) -> Bool{
        if note.folders.contains(folderName) {
            return false
        }
        
        self.db.collection("notes").document(note.id).updateData([
            "folders": note.folders.filter{ n in n != folderName }
        ]) { (err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
        }
        return true
    }
    
    func saveNote(note: Note) {
        if note.id != "" {
            self.db.collection("notes").document(note.id).updateData([
                "title": note.title,
                "content": note.content
            ]) { (err) in
                if err != nil{
                    print((err?.localizedDescription)!)
                    return
                }
            }
        }
        else {
            db.collection("notes").document().setData([
                "title": note.title,
                "folder": ["All"],
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
}
