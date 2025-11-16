import Foundation
import NaturalLanguage

/// Service for Apple Intelligence-powered text processing and analysis
@available(iOS 17.0, *)
class AppleIntelligenceService {
    
    // MARK: - Text Summarization
    
    /// Generate an intelligent summary of the text using Apple's Natural Language processing
    func summarize(text: String) -> String {
        guard !text.isEmpty else { return "" }
        
        // Use Apple's NLP to extract key sentences
        let tagger = NLTagger(tagSchemes: [.nameType, .lexicalClass])
        tagger.string = text
        
        // Split into sentences
        let sentences = text.components(separatedBy: CharacterSet(charactersIn: ".!?"))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        guard !sentences.isEmpty else { return text }
        
        // For short texts, return as is
        if sentences.count <= 2 {
            return text
        }
        
        // Extract important sentences based on length and content
        let importantSentences = sentences.prefix(min(3, sentences.count))
        return importantSentences.joined(separator: ". ") + (sentences.count > 3 ? "..." : ".")
    }
    
    // MARK: - Key Points Extraction
    
    /// Extract key points from text using NLP analysis
    func extractKeyPoints(from text: String) -> [String] {
        guard !text.isEmpty else { return [] }
        
        var keyPoints: [String] = []
        
        // Use NLTagger to identify important entities and concepts
        let tagger = NLTagger(tagSchemes: [.nameType, .lemma])
        tagger.string = text
        
        let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        
        // Extract named entities (people, places, organizations)
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, 
                            unit: .word,
                            scheme: .nameType, 
                            options: options) { tag, tokenRange in
            if let tag = tag, tag != .otherWord {
                let entity = String(text[tokenRange])
                if !entity.isEmpty && entity.count > 2 {
                    keyPoints.append(entity)
                }
            }
            return true
        }
        
        // If no entities found, extract important phrases
        if keyPoints.isEmpty {
            let sentences = text.components(separatedBy: CharacterSet(charactersIn: ".!?\n"))
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty && $0.count > 10 }
            
            keyPoints = Array(sentences.prefix(3))
        }
        
        return Array(keyPoints.prefix(5)) // Limit to 5 key points
    }
    
    // MARK: - Language Detection
    
    /// Detect the dominant language in the text
    func detectLanguage(in text: String) -> String? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        
        guard let languageCode = recognizer.dominantLanguage?.rawValue else {
            return nil
        }
        
        let locale = Locale(identifier: languageCode)
        return locale.localizedString(forLanguageCode: languageCode)
    }
    
    // MARK: - Sentiment Analysis
    
    /// Analyze the sentiment of the text (positive, negative, neutral)
    func analyzeSentiment(of text: String) -> String {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        
        let (sentiment, _) = tagger.tag(at: text.startIndex, 
                                        unit: .paragraph, 
                                        scheme: .sentimentScore)
        
        guard let sentimentValue = sentiment,
              let score = Double(sentimentValue.rawValue) else {
            return "Neutral"
        }
        
        if score > 0.3 {
            return "Positive"
        } else if score < -0.3 {
            return "Negative"
        } else {
            return "Neutral"
        }
    }
    
    // MARK: - Text Classification
    
    /// Classify the text into categories (note type detection)
    func classifyText(_ text: String) -> String {
        // Simple keyword-based classification for common note types
        let lowercasedText = text.lowercased()
        
        if lowercasedText.contains("todo") || lowercasedText.contains("task") || 
           lowercasedText.contains("checklist") {
            return "Task List"
        } else if lowercasedText.contains("meeting") || lowercasedText.contains("agenda") {
            return "Meeting Notes"
        } else if lowercasedText.contains("idea") || lowercasedText.contains("brainstorm") {
            return "Ideas"
        } else if lowercasedText.range(of: "\\d{1,2}/\\d{1,2}/\\d{2,4}", options: .regularExpression) != nil {
            return "Event/Date"
        } else {
            return "General Note"
        }
    }
    
    // MARK: - Text Enhancement
    
    /// Enhance text by fixing common issues and improving readability
    func enhanceText(_ text: String) -> String {
        var enhanced = text
        
        // Fix multiple spaces
        enhanced = enhanced.replacingOccurrences(of: "  +", 
                                                 with: " ", 
                                                 options: .regularExpression)
        
        // Fix multiple newlines
        enhanced = enhanced.replacingOccurrences(of: "\n\n+", 
                                                 with: "\n\n", 
                                                 options: .regularExpression)
        
        // Capitalize first letter after period
        enhanced = enhanced.replacingOccurrences(of: "(?<=\\. )[a-z]", 
                                                 with: "\\U$0", 
                                                 options: .regularExpression)
        
        return enhanced.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
