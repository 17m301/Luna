import SwiftUI

// MARK: - Profile Tab View
struct ProfileTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var showResetConfirmation = false
    
    var body: some View {
        ZStack {
            AppTheme.gradient.ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer().frame(height: 32)
                
                Image(systemName: appState.spiritAnimal)
                    .font(.system(size: 70))
                    .padding()
                    .background(Circle().fill(AppTheme.card))
                    .foregroundStyle(.white)
                
                Text(appState.userName)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Age group:")
                        Spacer()
                        Text(appState.ageGroup.isEmpty ? "Not set" : appState.ageGroup)
                    }
                    HStack {
                        Text("Sleep goal:")
                        Spacer()
                        Text(appState.sleepGoal.isEmpty ? "Not set" : appState.sleepGoal)
                    }
                    HStack {
                        Text("Target duration:")
                        Spacer()
                        Text(String(format: "%.1f h", appState.targetHours))
                    }
                    if !appState.userEmail.isEmpty {
                        HStack {
                            Text("Email:")
                            Spacer()
                            Text(appState.userEmail)
                        }
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.white)
                .padding()
                .background(AppTheme.card)
                .cornerRadius(20)
                .padding(.horizontal)
                
                Spacer()
                
                Button(role: .destructive) {
                    showResetConfirmation = true
                } label: {
                    Text("Reset Onboarding")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 40)
                
                Spacer().frame(height: 32)
            }
        }
        .alert("Reset onboarding?", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Erase & Restart", role: .destructive) {
                appState.resetOnboarding()
            }
        } message: {
            Text("This will clear your onboarding answers and start the flow again, but keep you signed in.")
        }
    }
}

