import SwiftUI

// MARK: - Challenges Question Screen
struct ChallengesQuestionScreen: View {
    @Binding var selection: String
    var onContinue: () -> Void
    
    private let options: [(label: String, icon: String)] = [
        ("Trouble falling asleep", "moon.zzz.fill"),
        ("Busy mind", "brain.head.profile"),
        ("Inconsistent schedule", "deskclock.fill"),
        ("Stress relief", "bolt.heart"),
        ("Noise sensitivity", "speaker.wave.3.fill")
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("What's keeping\nyou up?")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(options, id: \.label) { item in
                    Button(action: { selection = item.label }) {
                        HStack(spacing: 12) {
                            Image(systemName: item.icon)
                                .font(.subheadline)
                            Text(item.label)
                                .font(.headline)
                            Spacer()
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 14)
                        .background(selection == item.label ? AppTheme.accent.opacity(0.3) : AppTheme.card)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
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

