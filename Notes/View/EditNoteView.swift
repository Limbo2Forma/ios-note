import SwiftUI
import Firebase
import MDText

struct EditNoteView : View {
    
    var note: Note?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var title = ""
    @State private var content = ""
    
    init() {
        if note != nil {
            title = note?.title ?? ""
            content = note?.content ?? ""
        }
    }
    
    
    
    var body : some View{
        
        VStack() {
            Form {
                TextField("Note Title", text: $title)
            }
            Text("Tetert")
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                
                Text("Save").padding(.vertical).padding(.horizontal,25).foregroundColor(.white)
                
            }.background(Color.red)
            .clipShape(Capsule())
            .padding()
            
        }.edgesIgnoringSafeArea(.bottom)
    }
}
