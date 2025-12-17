import SwiftUI

// MARK: - Body Scan Session View
struct BodyScanSessionView: View {
    @Environment(\.dismiss) var dismiss
    
    private let steps: [String] = [
        "Close your eyes and take a deep breath.",
        "Bring attention to the top of your head and relax your forehead.",
        "Release tension around your eyes and jaw.",
        "Let your shoulders drop away from your ears.",
        "Notice any tightness in your chest and belly, and soften.",
        "Scan down through your hips, legs and all the way to your toes."
    ]
    
    var body: some View {
        ZStack {
            AppTheme.gradient.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.down")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(Circle().fill(.white.opacity(0.1)))
                    }
                    Spacer()
                }
                .padding()
                
                Text("Body Scan")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                
                Text("Move your attention slowly from head to toe.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.horizontal)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: 12) {
                                Text("\(index + 1).")
                                    .font(.headline)
                                    .foregroundStyle(AppTheme.accent)
                                Text(step)
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

