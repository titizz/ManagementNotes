//
//  Item.swift
//  ManagementNotes
//
//  Created by Thierry Decock on 16/11/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var text: String
    var createdAt: Date
    var imageData: Data?
    
    init(text: String, createdAt: Date = .now, imageData: Data? = nil) {
        self.text = text
        self.createdAt = createdAt
        self.imageData = imageData
    }
}
