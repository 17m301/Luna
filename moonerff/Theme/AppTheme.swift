import SwiftUI

// MARK: - App Theme & Colors
struct AppTheme {
    static let gradient = LinearGradient(
        colors: [
            Color(red: 0.1, green: 0.05, blue: 0.3), // Deep Indigo
            Color(red: 0.3, green: 0.15, blue: 0.6), // Soft Purple
            Color(red: 0.2, green: 0.5, blue: 0.9)   // Dreamy Blue
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accent = Color(red: 0.4, green: 0.2, blue: 1.0)
    static let card = Color.black.opacity(0.3)
}

