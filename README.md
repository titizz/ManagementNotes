# Management Notes

An intelligent iOS app for capturing and managing handwritten notes using Apple's advanced text recognition and Apple Intelligence features.

## Features

### 📸 Handwritten Text Recognition
- Capture notes using your device's camera or photo library
- Advanced OCR powered by Apple's Vision framework
- Optimized for both printed and handwritten text
- Multi-language support: English, French, Spanish, German, Italian, Portuguese
- Automatic language detection

### 🧠 Apple Intelligence Integration
The app uses Apple's Natural Language framework to provide intelligent insights:

#### Text Summarization
- Automatically generates concise summaries of your notes
- Extracts the most important sentences
- Perfect for quickly reviewing long notes

#### Key Points Extraction
- Identifies and highlights important entities, concepts, and phrases
- Uses Named Entity Recognition (NER)
- Displays up to 5 key points per note

#### Smart Classification
- Automatically categorizes notes:
  - Task Lists
  - Meeting Notes
  - Ideas & Brainstorming
  - Events/Dates
  - General Notes

#### Language Detection
- Automatically detects the language of your notes
- Supports multilingual notes

#### Sentiment Analysis
- Analyzes the emotional tone of your notes
- Categories: Positive, Negative, Neutral
- Useful for tracking mood in journal entries

#### Text Enhancement
- Automatically improves text formatting
- Fixes multiple spaces and line breaks
- Capitalizes sentences properly

### 💾 Data Persistence
- All notes are stored locally using SwiftData
- Images are saved with compression for efficient storage
- All AI-generated insights are stored with each note
- Complete privacy - all processing happens on-device

### 🎨 Beautiful UI
- Clean, modern SwiftUI interface
- Category badges for quick identification
- Rich detail view with comprehensive AI insights
- Intuitive navigation and editing
- Dark mode support

## Requirements

- iOS 17.0 or later
- Camera access for capturing notes
- Photo library access (when camera unavailable)

## Privacy

All text recognition and Apple Intelligence processing happens entirely on your device. Your notes and their insights never leave your device, ensuring complete privacy.

## Technical Details

### Frameworks Used
- **Vision**: For handwritten text recognition
- **Natural Language**: For Apple Intelligence features
- **SwiftUI**: For the user interface
- **SwiftData**: For data persistence
- **UIKit**: For camera integration

### Architecture
- **MVVM Pattern**: Clean separation of concerns
- **Async/Await**: Modern Swift concurrency
- **SwiftData Models**: Type-safe data persistence
- **Service Layer**: Encapsulated AI functionality

### Key Components
- `TextRecognizer.swift`: Vision-based OCR
- `AppleIntelligenceService.swift`: AI-powered text analysis
- `Item.swift`: SwiftData model for notes
- `ContentView.swift`: Main list view
- `NoteDetailView.swift`: Detailed note view with insights
- `ImagePickerView.swift`: Camera/photo library integration

## How It Works

1. **Capture**: Tap the camera button to capture a note
2. **Recognition**: The app uses Vision framework to extract text
3. **Analysis**: Apple Intelligence analyzes the text in multiple ways
4. **Storage**: The note, image, and all insights are saved
5. **Review**: View your note with AI-generated insights

## Future Enhancements

Potential future features:
- iCloud sync across devices
- Export notes as PDF or text
- Search functionality
- Tags and manual categorization
- Voice notes transcription
- OCR confidence scores
- Custom category training

## License

This project is created for educational and personal use.

## Credits

Developed using Apple's latest AI and machine learning frameworks.
