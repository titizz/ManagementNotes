//
//  ContentView.swift
//  ManagementNotes
//
//  Created by Thierry Decock on 16/11/2025.
//

import SwiftUI
import SwiftData
import UIKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Item.createdAt, order: .reverse) private var items: [Item]
    @State private var showingCamera = false
    @State private var isProcessing = false
    @State private var alertInfo: AlertInfo?
    private let textRecognizer = TextRecognizer()
    private let aiService = AppleIntelligenceService()

    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    if items.isEmpty {
                        ContentUnavailableView(
                            "No notes yet",
                            systemImage: "note.text",
                            description: Text("Scan a note to capture it as text.")
                        )
                    } else {
                        ForEach(items) { item in
                            NavigationLink {
                                NoteDetailView(item: item)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    // Show category badge if available
                                    if let category = item.category {
                                        Text(category)
                                            .font(.caption2)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.blue.opacity(0.2))
                                            .foregroundColor(.blue)
                                            .clipShape(Capsule())
                                    }
                                    
                                    // Show summary if available, otherwise show original text
                                    Text(item.summary ?? (item.text.isEmpty ? "No text recognized" : item.text))
                                        .font(.body)
                                        .lineLimit(2)
                                    Text(item.createdAt, format: Date.FormatStyle(date: .numeric, time: .shortened))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
                .disabled(isProcessing)

                if isProcessing {
                    ProgressView("Analyzing with Apple Intelligence…")
                        .padding(24)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .navigationTitle("Management Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingCamera = true }) {
                        Label("Scan Note", systemImage: "camera")
                    }
                    .disabled(isProcessing)
                }
            }
            .sheet(isPresented: $showingCamera) {
                ImagePickerView(sourceType: preferredSourceType) { image in
                    Task { await processCapturedImage(image) }
                }
            }
            .alert(item: $alertInfo) { info in
                Alert(title: Text(info.title), message: Text(info.message), dismissButton: .default(Text("OK")))
            }
        }
    }

    private var preferredSourceType: UIImagePickerController.SourceType {
        UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
    }

    private func processCapturedImage(_ image: UIImage) async {
        guard let cgImage = image.cgImage else {
            presentError("Could not read the captured image.")
            return
        }

        await MainActor.run { isProcessing = true }
        do {
            let recognizedText = try await textRecognizer.recognizeText(in: cgImage)
            let cleanedText = recognizedText.trimmingCharacters(in: .whitespacesAndNewlines)

            guard !cleanedText.isEmpty else {
                presentError("No readable text was found in the photo.")
                await MainActor.run { isProcessing = false }
                return
            }

            let imageData = image.jpegData(compressionQuality: 0.8)
            
            // Use Apple Intelligence to analyze the text
            let summary = aiService.summarize(text: cleanedText)
            let keyPoints = aiService.extractKeyPoints(from: cleanedText)
            let category = aiService.classifyText(cleanedText)
            let language = aiService.detectLanguage(in: cleanedText)
            let sentiment = aiService.analyzeSentiment(of: cleanedText)
            let enhancedText = aiService.enhanceText(cleanedText)
            
            await MainActor.run {
                let item = Item(text: enhancedText, createdAt: .now, imageData: imageData)
                item.summary = summary
                item.keyPoints = keyPoints
                item.category = category
                item.detectedLanguage = language
                item.sentiment = sentiment
                modelContext.insert(item)
                isProcessing = false
            }
        } catch {
            presentError(error.localizedDescription)
            await MainActor.run { isProcessing = false }
        }
    }

    @MainActor
    private func presentError(_ message: String) {
        alertInfo = AlertInfo(title: "Scan Failed", message: message)
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

private struct AlertInfo: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
