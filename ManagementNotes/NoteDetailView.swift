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

                // Apple Intelligence Insights Section
                if item.category != nil || item.sentiment != nil || item.detectedLanguage != nil {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Apple Intelligence Insights")
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        HStack(spacing: 12) {
                            if let category = item.category {
                                Label(category, systemImage: "tag.fill")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.15))
                                    .clipShape(Capsule())
                            }
                            
                            if let sentiment = item.sentiment {
                                Label(sentiment, systemImage: sentimentIcon(for: sentiment))
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(sentimentColor(for: sentiment))
                                    .clipShape(Capsule())
                            }
                            
                            if let language = item.detectedLanguage {
                                Label(language, systemImage: "globe")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.purple.opacity(0.15))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Summary Section
                if let summary = item.summary, !summary.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Summary")
                            .font(.headline)
                        Text(summary)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.secondary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                
                // Key Points Section
                if let keyPoints = item.keyPoints, !keyPoints.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Key Points")
                            .font(.headline)
                        ForEach(keyPoints, id: \.self) { point in
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 6))
                                    .foregroundColor(.blue)
                                    .padding(.top, 6)
                                Text(point)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                // Full Text Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Full Text")
                        .font(.headline)
                    Text(item.text.isEmpty ? "No text recognized" : item.text)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Text(item.createdAt, format: Date.FormatStyle(date: .long, time: .shortened))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle("Note")
    }
    
    // Helper functions for sentiment display
    private func sentimentIcon(for sentiment: String) -> String {
        switch sentiment {
        case "Positive": return "face.smiling"
        case "Negative": return "face.dashed"
        default: return "minus.circle"
        }
    }
    
    private func sentimentColor(for sentiment: String) -> Color {
        switch sentiment {
        case "Positive": return Color.green.opacity(0.15)
        case "Negative": return Color.red.opacity(0.15)
        default: return Color.gray.opacity(0.15)
        }
    }
}

#Preview {
    NoteDetailView(item: Item(text: "Sample", createdAt: .now))
}
