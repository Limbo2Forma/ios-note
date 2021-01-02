import SwiftUI
import Firebase

struct EditView : View {
    
    var note: Note
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var title: String
    @State var content: String
    
    var body : some View{
        
        ZStack(alignment: .bottomTrailing) {
            
            Text(note.content)
                .padding()
                .background(Color.black.opacity(0.05))
            
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
