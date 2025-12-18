import SwiftUI

// MARK: - Satisfaction Question Screen
struct SatisfactionQuestionScreen: View {
    @Binding var selection: String
    var onContinue: () -> Void
    
    private let options: [(label: String, emoji: String)] = [
        ("Very satisfied", "😴"),
        ("Somewhat satisfied", "🙂"),
        ("Somewhat unsatisfied", "😕"),
        ("Very unsatisfied", "😣")
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("How satisfied are you\nwith your sleep?")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
            
            VStack(spacing: 14) {
                ForEach(options, id: \.label) { item in
                    Button(action: { selection = item.label }) {
                        HStack(spacing: 14) {
                            Text(item.emoji)
                                .font(.system(size: 28))
                            Text(item.label)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selection == item.label ? Color.white.opacity(0.2) : AppTheme.card)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(selection == item.label ? AppTheme.accent : Color.white.opacity(0.2), lineWidth: 1)
                        )
                        .foregroundStyle(.white)
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            Button(action: onContinue) {
                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selection.isEmpty ? Color.gray : AppTheme.accent)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
            .padding(40)
            .disabled(selection.isEmpty)
        }
    }
}


