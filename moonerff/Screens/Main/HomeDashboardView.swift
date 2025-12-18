import SwiftUI

// MARK: - Home Dashboard View
struct HomeDashboardView: View {
    @EnvironmentObject var appState: AppState
    @Binding var showPaywall: Bool
    @Binding var showLogoutConfirmation: Bool
    @State private var tip: Tip?
    var body: some View {
        ZStack {
            AppTheme.gradient.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text("Good night")
                            .font(.headline).foregroundStyle(.white.opacity(0.7))
                        Text(appState.userName)
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    HStack(spacing: 12) {
                        Button(action: { showPaywall = true }) {
                            Image(systemName: appState.spiritAnimal)
                                .font(.title)
                                .padding()
                                .background(Circle().fill(.white.opacity(0.1)))
                                .foregroundStyle(.white)
                        }
                        
                        Button(action: { showLogoutConfirmation = true }) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.title3)
                                .padding()
                                .background(Circle().fill(.white.opacity(0.1)))
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 40)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Pre-ritual options
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Tonight's Ritual")
                                .font(.headline)
                                .foregroundStyle(.white)
                            
                            HStack(spacing: 12) {
                                RitualPill(title: "Quick Wind‑Down", icon: "wind")
                                RitualPill(title: "Deep Relax", icon: "sparkles")
                            }
                            
                            HStack(spacing: 12) {
                                RitualPill(title: "Breathing", icon: "lungs.fill")
                                RitualPill(title: "Story Mode", icon: "book.fill")
                            }
                        }
                        .padding()
                        .background(AppTheme.card)
                        .cornerRadius(24)
                        
                        // Main ritual button
                        Button(action: {
                            if !appState.isSubscribed { showPaywall = true }
                            else { print("Ritual Started") }
                        }) {
                            VStack(spacing: 15) {
                                HStack {
                                    Image(systemName: "lightbulb.fill")
                                        .font(.title2)
                                        .foregroundStyle(AppTheme.accent)
                                        .padding(.horizontal)
                                    
                                    Text(tip?.tips ?? "")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .multilineTextAlignment(.center)
                                    Spacer()
                                }
                                .font(.headline).foregroundStyle(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 30)
                            .background(AppTheme.card)
                            .cornerRadius(30)
                            .onAppear() {
                                tip = tips.randomElement()
                            }
                        }
                        
                        // Goal Display
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Your Goal")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                                Text("\(String(format: "%.1f", appState.targetHours)) Hours")
                                    .font(.title2.bold())
                                    .foregroundStyle(.white)
                            }
                            Spacer()
                            Image(systemName: "target")
                                .font(.title)
                                .foregroundStyle(AppTheme.accent)
                        }
                        .padding()
                        .background(AppTheme.card)
                        .cornerRadius(20)
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    let mockAppState = AppState()
    mockAppState.userName = "Ajith"
    mockAppState.isSubscribed = false
    mockAppState.spiritAnimal = "moon.stars.fill"
    mockAppState.targetHours = 8.0
    
    return HomeDashboardView(
        showPaywall: .constant(false),
        showLogoutConfirmation: .constant(false)
    )
    .environmentObject(mockAppState)
}


