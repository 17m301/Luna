import SwiftUI

// MARK: - Main Tab View (Home / Music / Meditate / Results / Profile)
struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var showPaywall = false
    @State private var showLogoutConfirmation = false
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            AppTheme.gradient.ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                HomeDashboardView(
                    showPaywall: $showPaywall,
                    showLogoutConfirmation: $showLogoutConfirmation
                )
                .environmentObject(appState)
                .tag(0)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                
                MusicTabView()
                    .tag(1)
                    .tabItem {
                        Image(systemName: "music.note")
                        Text("Music")
                    }
                
                MeditateTabView()
                    .tag(2)
                    .tabItem {
                        Image(systemName: "leaf.fill")
                        Text("Meditate")
                    }
                
                ResultsTabView()
                    .environmentObject(appState)
                    .tag(3)
                    .tabItem {
                        Image(systemName: "moon.zzz.fill")
                        Text("Results")
                    }
                
                ProfileTabView()
                    .environmentObject(appState)
                    .tag(4)
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Profile")
                    }
            }
            .accentColor(AppTheme.accent)
        }
        .sheet(isPresented: $showPaywall) {
            SubscriptionView()
        }
        .alert("Log Out", isPresented: $showLogoutConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Log Out", role: .destructive) {
                appState.logout()
            }
        } message: {
            Text("Are you sure you want to log out?")
        }
    }
}


