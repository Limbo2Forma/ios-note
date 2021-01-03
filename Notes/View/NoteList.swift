//
//  NoteList.swift
//  Notes
//
//  Created by A friend on 1/3/21.
//  Copyright © 2021 Balaji. All rights reserved.
//

import SwiftUI

struct NoteList: View {
    var notes
    @State var removeMode = false
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                Text("Notes").font(.title).foregroundColor(.white)
                Spacer()
                Button(action: {
                    self.removeMode.toggle()
                }) {
                Image(systemName: self.removeMode ? "xmark.circle" : "trash").resizable().frame(width: 23, height: 23).foregroundColor(.white)
                }
            }.padding()
            .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
            .background(Color.red)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    ForEach(AllFolders.data){i in
                        NavigationLink(destination: NoteList(note: i)) {
                            ListElement(note: i, isRemovedMode: removeMode)
                        }
                    }
                }
            }
        }.edgesIgnoringSafeArea(.top)
    }
}

struct NoteList_Previews: PreviewProvider {
    static var previews: some View {
        NoteList()
    }
}
