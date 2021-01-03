import SwiftUI
import Firebase
import MDText

struct EditNoteView : View {
    
    var note: Note?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var title = ""
    @State private var content = ""
    
    var body : some View{
        VStack() {
            Form {
                TextField("Note Title", text: $title)
                //RichDemoRepresentable()
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
