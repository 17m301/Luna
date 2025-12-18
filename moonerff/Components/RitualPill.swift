import SwiftUI

// MARK: - Ritual Pill Component
struct RitualPill: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.subheadline)
            Text(title)
                .font(.subheadline.bold())
        }
        .foregroundStyle(.white)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(AppTheme.accent.opacity(0.4))
        .clipShape(Capsule())
    }
}


