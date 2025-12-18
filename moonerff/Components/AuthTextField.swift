import SwiftUI

// MARK: - Reusable Auth Text Field
struct AuthTextField: View {
    let title: String
    @Binding var text: String
    var icon: String? = nil
    var keyboard: UIKeyboardType = .default
    
    var body: some View {
        HStack(spacing: 12) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(width: 20)
            }
            
            TextField(title, text: $text)
                .keyboardType(keyboard)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .foregroundStyle(.white)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.card)
        )
    }
}


