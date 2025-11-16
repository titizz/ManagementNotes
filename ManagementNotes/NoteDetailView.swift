import SwiftUI

struct NoteDetailView: View {
    let item: Item

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let data = item.imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Text(item.text.isEmpty ? "No text recognized" : item.text)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(item.createdAt, format: Date.FormatStyle(date: .long, time: .shortened))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle("Note")
    }
}

#Preview {
    NoteDetailView(item: Item(text: "Sample", createdAt: .now))
}
