import SwiftUI
import Combine

// MARK: - App State (Manages Flow & User Data)
class AppState: ObservableObject {
    @AppStorage("isOnboardingDone") var isOnboardingDone: Bool = false
    @AppStorage("isSignedUp") var isSignedUp: Bool = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("spiritAnimal") var spiritAnimal: String = "pawprint.fill"
    @AppStorage("isSubscribed") var isSubscribed: Bool = false
    @AppStorage("userName") var userName: String = "Guest"
    @AppStorage("userEmail") var userEmail: String = ""
    @AppStorage("ageGroup") var ageGroup: String = ""
    
    // Questionnaire Data
    @AppStorage("sleepGoal") var sleepGoal: String = ""
    @AppStorage("targetHours") var targetHours: Double = 8.0
    
    // Simple 7-day mock data for the Results tab
    @Published var lastSevenDays: [SleepDay] = SleepDay.sampleWeek
    
    func reset() {
        isSignedUp = false
        isLoggedIn = false
        isOnboardingDone = false
        isSubscribed = false
    }
    
    // Resets onboarding/questions without logging the user out
    func resetOnboarding() {
        isOnboardingDone = false
        sleepGoal = ""
        targetHours = 8.0
    }
    
    func logout() {
        isLoggedIn = false
    }
}

