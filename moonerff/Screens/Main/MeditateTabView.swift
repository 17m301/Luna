import SwiftUI

// MARK: - Meditate / Pre-Ritual Tab View
struct MeditateTabView: View {
    enum Practice: String, Identifiable {
        case breathing, bodyScan, gratitude, stretching
        var id: String { rawValue }
    }
    
    let practices: [(title: String, icon: String, subtitle: String, practice: Practice)] = [
        ("Guided Breathing", "lungs.fill", "3–5 min reset", .breathing),
        ("Meditate", "figure.mind.and.body", "Full body relaxation", .bodyScan),
        ("Gratitude Notes", "heart.text.square.fill", "End the day on a high", .gratitude),
        ("Mindful Stretching", "figure.cooldown", "Release tension", .stretching)
    ]
    
    @State private var activePractice: Practice?
    
    var body: some View {
        ZStack {
            AppTheme.gradient.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Pre‑Ritual")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.top, 32).padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(practices, id: \.title) { item in
                            Button(action: { activePractice = item.practice }) {
                                HStack(alignment: .top, spacing: 16) {
                                    Image(systemName: item.icon)
                                        .font(.title2)
                                        .foregroundStyle(AppTheme.accent)
                                        .frame(width: 32)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.title)
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                        Text(item.subtitle)
                                            .font(.subheadline)
                                            .foregroundStyle(.white.opacity(0.7))
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(AppTheme.card)
                                .cornerRadius(22)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.vertical)
                }
                .padding(.horizontal)
            }
        }
        .sheet(item: $activePractice) { practice in
            switch practice {
            case .breathing:
                BreathingSessionView()
            case .bodyScan:
                BodyScanSessionView()
            case .gratitude:
                GratitudeNotesView()
            case .stretching:
                StretchingSessionView()
            }
        }
    }
}

