import SwiftUI

// MARK: - Stretching Session View
struct StretchingSessionView: View {
    @Environment(\.dismiss) var dismiss
    
    private let stretches: [(String, String)] = [
        ("Neck rolls", "Gently roll your head side to side to release tension."),
        ("Shoulder circles", "Lift and roll your shoulders backwards 5–8 times."),
        ("Forward fold", "Hinge at the hips and let your arms hang toward the floor."),
        ("Quad stretch", "Standing, pull one foot toward your glutes and hold."),
        ("Ankle circles", "Rotate each ankle slowly in both directions.")
    ]
    
    var body: some View {
        ZStack {
            AppTheme.gradient.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
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
                
                Text("Mindful Stretching")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(stretches, id: \.0) { item in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.0)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                Text(item.1)
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                            .padding()
                            .background(AppTheme.card)
                            .cornerRadius(18)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}


