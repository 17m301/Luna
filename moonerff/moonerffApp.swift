import SwiftUI

// MARK: - App Entry Point
@main
struct MoonerFullApp: App {
    @StateObject var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if !appState.isSignedUp {
                    SignUpScreen()
                        .environmentObject(appState)
                } else if !appState.isLoggedIn {
                    LoginScreen()
                        .environmentObject(appState)
                } else if appState.isOnboardingDone {
                    MainTabView()
                        .environmentObject(appState)
                } else {
                    // The Master Onboarding Flow
                    OnboardingOrchestrator()
                        .environmentObject(appState)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

