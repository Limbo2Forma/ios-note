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
    @Published var currentNoteContent = String()
    @Published var currentUser: User? = nil
    
    var db: DocumentReference? = nil
    let format = DateFormatter()
    var handle: AuthStateDidChangeListenerHandle?
    var folderListener: ListenerRegistration? = nil
    var noteListener: ListenerRegistration? = nil
    var listenerExist = false
    
    func listen () {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // if we have a user, create a new user model
                print("Got user: \(user)")
                self.currentUser = user
                Firestore.firestore().collection("users").document(user.uid).getDocument { (document, error) in
                    if let document = document, !document.exists {
                        Firestore.firestore().collection("users").document(user.uid).setData([
                            "email": user.email!,
                            "folders": ["All"]
                        ])
                    }
                    self.attachDataListener(user: user)
                }
            } else {
                print("user exit")
                self.currentUser = nil
                if self.listenerExist == true {
                    self.detachDataListener()
                }
            }
        }
    }
    
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func detachDataListener() {
        print("Detach Listener")
        if self.noteListener != nil {
            self.noteListener!.remove()
        }
        if self.folderListener != nil {
            self.folderListener!.remove()
        }
        self.notes = [Note]()
        self.noData = false
        self.folders = [String]()
        self.currentNoteContent = String()
        self.listenerExist = false
    }
    
    func attachDataListener(user: User) {
        print("Attach Listener")
        self.db = Firestore.firestore().collection("users").document(user.uid)
        self.listenerExist = true
        self.noteListener = self.db!.collection("notes").order(by: "date", descending: true).addSnapshotListener { (snap, err) in
            
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
                    let pinned = i.document.get("pinned") as! Bool
                    
                    self.format.dateFormat = "dd-MM-YY hh:mm a"
                    let dateString = self.format.string(from: date.dateValue())
                    
                    let newNote = Note(id: id, title: title, folders: folders, content: content, date:dateString, pinned: pinned)
                    self.notes.append(newNote)
                }
                
                if i.type == .modified {
                    let id = i.document.documentID
                    let title = i.document.get("title") as! String
                    let folders = i.document.get("folders") as! [String]
                    let content = i.document.get("content") as! String
                    let date = i.document.get("date") as! Timestamp
                    let pinned = i.document.get("pinned") as! Bool
                    
                    for i in 0..<self.notes.count {
                        if self.notes[i].id == id {
                            self.notes[i].title = title
                            self.notes[i].folders = folders
                            self.notes[i].content = content
                            self.notes[i].pinned = pinned
                            
                            self.format.dateFormat = "dd-MM-YY hh:mm a"
                            let dateString = self.format.string(from: date.dateValue())
                            
                            self.notes[i].date = dateString
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
            print("<><><>><><><><><><><>")
            print(self.notes)
        }
        
        self.folderListener = self.db!.addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                let fd = document.get("folders")
                if fd != nil {
                    self.folders = fd as! [String]
                }
                print("<><><>><><><><><><><>")
                print(self.folders)
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
    
    func getPinnedNotes() -> [Note] {
        return notes.filter { n in
            return n.pinned
        }
    }
    
    func dateStringInMilliseconds(_ dateString: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-MM-yy hh:mm a"
        let date = dateFormater.date(from: dateString)
        return Int(date!.timeIntervalSince1970 * 1000)
    }
//    func dateCompare(_ dateStr1: String, _ dateStr2: String) -> Bool {
//        let dateFormater = DateFormatter()
//        dateFormater.dateFormat = "dd-MM-yy hh:mm a"
//        let date1 = dateFormater.date(from: dateStr1)! as Date
//        let date2 = dateFormater.date(from: dateStr2)! as Date
//        let ansiDateFormatter = DateFormatter()
//        ansiDateFormatter.dateFormat = "yy-MM-dd HH:mm:ss"
//        let ansiDateStr1 = ansiDateFormatter.string(from: date1)
//        let ansiDateStr2 = ansiDateFormatter.string(from: date2)
//        print("        \(ansiDateStr1) vs \(ansiDateStr1) : \(ansiDateStr1 > ansiDateStr2)")
//        return ansiDateStr1 > ansiDateStr2
//    }
    func getNotesInFolder(folderName: String) -> [Note] {
        return notes.sorted(by: { (note1, note2) -> Bool in
            let result = dateStringInMilliseconds(note1.date) > dateStringInMilliseconds(note2.date)
//            let result = dateCompare(note1.date, note2.date)
//            print("compare \(note1.date) vs \(note2.date) : \(result)")
            return result
        }).filter { n in
            return n.folders.contains(folderName)
        }
    }
    
    func addFolder(folderName: String) -> Bool {
        if self.folders.contains(folderName) {
            return false
        }
        self.folders.append(folderName)
        self.db!.updateData([
            "folders": folders
        ]) { (err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
        }
        return true
    }
    
    func rearrangeFolder(folders: [String]) {
        self.db!.updateData([
            "folders": folders
        ]) { (err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
        }
    }
    
    func removeFolder(folderName: String) {
        let batch = Firestore.firestore().batch()
        
        for i in self.notes {
            if i.folders.contains(folderName) {
                batch.updateData([
                    "folders": i.folders.filter{ n in n != folderName }
                ], forDocument: db!.collection("notes").document(i.id))
            }
        }
        
        batch.updateData([
            "folders": self.folders.filter{ n in n != folderName }
        ], forDocument: db!)
        
        batch.commit() { (err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
        }
    }
    
    func renameFolder(oldName: String, newName: String) -> Bool {
        if self.folders.contains(newName) && oldName != newName {
            return true
        }
        
        if oldName == newName {
            return false
        }
        
        let batch = Firestore.firestore().batch()
        
        for i in self.notes {
            if let index = i.folders.firstIndex(of: oldName) {
                var newFolders = i.folders
                newFolders[index] = newName
                
                batch.updateData([
                    "folders": newFolders
                ], forDocument: db!.collection("notes").document(i.id))
            }
        }
        
        if let index = self.folders.firstIndex(of: oldName) {
            var newFolders = self.folders
            newFolders[index] = newName
            
            batch.updateData([
                "folders": newFolders
            ], forDocument: db!)
        }
        
        batch.commit() { (err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
        }
        return false
    }
    
    func pinNote(note: Note) -> Bool {
        self.db!.collection("notes").document(note.id).updateData([
            "pinned": !note.pinned
        ]) { (err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
        }
        return true
    }
    
    func addNoteInFolder(note: Note, folderName: String) -> Bool{
        if note.folders.contains(folderName) {
            return false
        }
        var noteph = note.folders
        noteph.append(folderName)
        
        self.db!.collection("notes").document(note.id).updateData([
            "folders": noteph
        ]) { (err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
        }
        return true
    }
    
    func removeNoteInFolder(note: Note, folderName: String) {
        self.db!.collection("notes").document(note.id).updateData([
            "folders": note.folders.filter{ n in n != folderName }
        ]) { (err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
        }
    }
    
    func createNote(title: String, content: String, destination: String) {
        db!.collection("notes").document().setData([
            "title": title,
            "folders": destination == "All" ? ["All"] : ["All", destination],
            "content": content,
            "pinned": false,
            "date": Date()
        ]) { (err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
        }
    }
    
    func updateNote(note: Note) {
        self.db!.collection("notes").document(note.id).updateData([
            "title": note.title,
            "content": note.content,
            "date": Date()
        ]) { (err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
        }
    }
    
    func deleteNote(note: Note) {
        self.db!.collection("notes").document(note.id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}
