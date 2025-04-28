import SwiftUI

// Модель заметки
struct Note: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var content: String
}

// Основной экран со списком заметок
struct ContentView: View {
    @State private var notes: [Note] = []
    @State private var isShowingAddNoteView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(notes) { note in
                    NavigationLink(destination: NoteDetailView(note: note)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(note.title)
                                .font(.headline)
                            Text(note.content)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                }
                .onDelete(perform: deleteNotes)
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingAddNoteView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("AddNoteButton")
                }
            }
            .sheet(isPresented: $isShowingAddNoteView) {
                AddNoteView(notes: $notes)
            }
        }
    }

    private func deleteNotes(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }
}

// Экран добавления новой заметки
struct AddNoteView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var notes: [Note]

    @State private var title = ""
    @State private var content = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $title)
                        .accessibilityIdentifier("TitleTextField")
                }
                
                Section(header: Text("Content")) {
                    TextEditor(text: $content)
                        .frame(minHeight: 150)
                        .accessibilityIdentifier("ContentTextEditor")
                }
            }
            .navigationTitle("New Note")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveNote()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                    .accessibilityIdentifier("SaveNoteButton")
                }
            }
        }
    }
    
    private func saveNote() {
        let newNote = Note(title: title, content: content)
        notes.append(newNote)
        dismiss()
    }
}

// Экран детального просмотра заметки
struct NoteDetailView: View {
    let note: Note

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(note.title)
                    .font(.largeTitle)
                    .bold()
                Text(note.content)
                    .font(.body)
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Detail")
    }
}

// Превью для SwiftUI
#Preview {
    ContentView()
}
