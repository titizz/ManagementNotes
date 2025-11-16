import Foundation
import Vision

struct TextRecognizer {
    func recognizeText(in cgImage: CGImage) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                let recognizedStrings = (request.results as? [VNRecognizedTextObservation])?
                    .compactMap { $0.topCandidates(1).first?.string }
                    .joined(separator: "\n") ?? ""
                continuation.resume(returning: recognizedStrings)
            }
            // Configure for optimal text recognition including handwritten text
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            request.automaticallyDetectsLanguage = true
            
            // Enable recognition of both printed and handwritten text
            // This supports handwritten text detection on iOS 14+
            if #available(iOS 14.0, *) {
                request.recognitionLanguages = ["en-US", "fr-FR", "es-ES", "de-DE", "it-IT", "pt-BR"]
            }

            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try requestHandler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
