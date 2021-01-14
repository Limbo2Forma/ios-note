import SwiftUI
import Firebase

struct EditNoteView : View {
    
    var note: Note?
    var destination: String
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var data: FirestoreDb
    
    @State private var title = ""
    @State private var noteContent = ""
    
    var body : some View{
        VStack() {
            TextField("Note Title", text: $title)
                .padding(10)
                .font(.title)
            Divider()
            TextEditorView(initContent: note?.content ?? "", noteContent: $noteContent)
        }
        .onAppear {
            self.title = note?.title ?? ""
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarItems(trailing:
            HStack(spacing: 20) {
                Button(action: {
                    print(noteContent)
                    self.presentationMode.wrappedValue.dismiss()
                    }) {
                    Image(systemName: "checkmark").resizable().frame(width: 26, height: 23).foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
                        .font(Font.title.weight(.thin))
                    }
            })
    }
}
