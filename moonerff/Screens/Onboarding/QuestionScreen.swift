import SwiftUI

// MARK: - Generic Question Screen
struct QuestionScreen: View {
    let title: String
    let options: [String]
    @Binding var selection: String
    var onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text(title)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
            
            VStack(spacing: 12) {
                ForEach(options, id: \.self) { option in
                    Button(action: { selection = option }) {
                        Text(option)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(selection == option ? Color.white.opacity(0.2) : Color.clear)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
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

