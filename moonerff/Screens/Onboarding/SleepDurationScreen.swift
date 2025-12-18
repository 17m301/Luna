import SwiftUI

// MARK: - Sleep Duration Setup Screen
struct SleepDurationScreen: View {
    @Binding var hours: Double
    var onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            Text("Set Sleep Goal")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            
            VStack(spacing: 5) {
                Text("\(String(format: "%.1f", hours))")
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text("hours")
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            // Slider 6-12
            HStack {
                Text("6h").foregroundStyle(.white.opacity(0.5))
                Slider(value: $hours, in: 6.0...12.0, step: 0.5)
                    .tint(AppTheme.accent)
                Text("12h").foregroundStyle(.white.opacity(0.5))
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            Button(action: onContinue) {
                Text("Set Goal")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppTheme.accent)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
            .padding(40)
        }
    }
}


