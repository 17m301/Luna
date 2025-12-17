import SwiftUI
import Combine
import Foundation
import AVFoundation

// MARK: - 1. THEME & ASSETS
struct AppTheme {
    static let gradient = LinearGradient(
        colors: [
            Color(red: 0.1, green: 0.05, blue: 0.3), // Deep Indigo
            Color(red: 0.3, green: 0.15, blue: 0.6), // Soft Purple
            Color(red: 0.2, green: 0.5, blue: 0.9)   // Dreamy Blue
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accent = Color(red: 0.4, green: 0.2, blue: 1.0)
    static let card = Color.black.opacity(0.3)
}

// Breathing session modal
struct BreathingSessionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isInhaling: Bool = true
    @State private var scale: CGFloat = 0.6
    @State private var audioPlayer: AVAudioPlayer?
    private let phaseDuration: TimeInterval = 5.0 // seconds per inhale/exhale
    
    var body: some View {
        ZStack {
            AppTheme.gradient.ignoresSafeArea()
            
            VStack(spacing: 28) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(Circle().fill(.white.opacity(0.1)))
                    }
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                Text("Guided Breathing")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                
                Text("Inhale for 5s · Exhale for 5s")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                
                ZStack {
                    Circle()
                        .fill(AppTheme.accent.opacity(0.25))
                        .frame(width: 220, height: 220)
                    Circle()
                        .fill(AppTheme.accent)
                        .frame(width: 160, height: 160)
                        .scaleEffect(scale)
                        .animation(.easeInOut(duration: phaseDuration), value: scale)
                }
                .padding(.vertical, 10)
                
                Text(isInhaling ? "Inhale" : "Exhale")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                
                Text("Follow the expanding circle to breathe.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                
                Spacer()
            }
        }
        .onAppear { startBreathingLoop();playMusic() }
        .onDisappear { audioPlayer?.stop() }
    }
    
    private func startBreathingLoop() {
        scale = 1.05
        Timer.scheduledTimer(withTimeInterval: phaseDuration, repeats: true) { _ in
            isInhaling.toggle()
            withAnimation(.easeInOut(duration: phaseDuration)) {
                scale = isInhaling ? 1.05 : 0.6
            }
        }
    }
    
    private func playMusic() {
        guard let url = Bundle.main.url(forResource: "breathing", withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 
            audioPlayer?.play()
        } catch {
            print("Couldn't load audio file: \(error.localizedDescription)")
        }
    }
}

#Preview {
    BreathingSessionView()
}
// MARK: - 2. APP STATE (Manages Flow & User Data)
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
    
    // Simple 7‑day mock data for the Results tab
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

// MARK: - 3. ENTRY POINT
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

// MARK: - 3A. AUTH SCREENS

struct SignUpScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        ZStack {
            AppTheme.gradient.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Header Section
                VStack(spacing: 12) {
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(AppTheme.accent)
                        .symbolEffect(.bounce, value: isFormValid)
                    
                    Text("Create your account")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    Text("Start your journey to better sleep")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 48)
                
                // Form Fields
                VStack(spacing: 20) {
                    AuthTextField(
                        title: "Name",
                        text: $name,
                        icon: "person.fill"
                    )
                    
                    AuthTextField(
                        title: "Email",
                        text: $email,
                        icon: "envelope.fill",
                        keyboard: .emailAddress
                    )
                    
                    SecureAuthField(
                        title: "Password",
                        text: $password,
                        isVisible: $isPasswordVisible
                    )
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Sign Up Button
                Button(action: completeSignUp) {
                    HStack {
                        Text("Sign Up")
                            .font(.headline)
                        Image(systemName: "arrow.right")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(isFormValid ? AppTheme.accent : Color.gray.opacity(0.5))
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                    .scaleEffect(isFormValid ? 1.0 : 0.98)
                }
                .disabled(!isFormValid)
                .animation(.spring(response: 0.3), value: isFormValid)
                .padding(.horizontal, 40)
                
                // Log In Link
                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                    Button(action: {
                        withAnimation(.spring()) {
                            appState.isSignedUp = true
                        }
                    }) {
                        Text("Log In")
                            .font(.subheadline.bold())
                            .foregroundStyle(AppTheme.accent)
                    }
                }
                .padding(.bottom, 32)
            }
        }
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        password.count >= 6
    }
    
    private func completeSignUp() {
        withAnimation(.spring()) {
            appState.userName = name
            appState.userEmail = email
            appState.isSignedUp = true
        }
    }
}

struct LoginScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        ZStack {
            AppTheme.gradient.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Header Section
                VStack(spacing: 12) {
                    Image(systemName: "moon.zzz.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(AppTheme.accent)
                        .symbolEffect(.bounce, value: isFormValid)
                    
                    Text("Welcome back")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    Text("Continue your sleep journey")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 48)
                
                // Form Fields
                VStack(spacing: 20) {
                    AuthTextField(
                        title: "Email",
                        text: $email,
                        icon: "envelope.fill",
                        keyboard: .emailAddress
                    )
                    
                    SecureAuthField(
                        title: "Password",
                        text: $password,
                        isVisible: $isPasswordVisible
                    )
                    
                    // Forgot Password Link
                    HStack {
                        Spacer()
                        Button(action: {}) {
                            Text("Forgot password?")
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.accent)
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, -8)
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Log In Button
                Button(action: completeLogin) {
                    HStack {
                        Text("Log In")
                            .font(.headline)
                        Image(systemName: "arrow.right")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(isFormValid ? AppTheme.accent : Color.gray.opacity(0.5))
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                    .scaleEffect(isFormValid ? 1.0 : 0.98)
                }
                .disabled(!isFormValid)
                .animation(.spring(response: 0.3), value: isFormValid)
                .padding(.horizontal, 40)
                
                // Sign Up Link
                HStack(spacing: 4) {
                    Text("Don't have an account?")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                    Button(action: {
                        withAnimation(.spring()) {
                            appState.isSignedUp = false
                        }
                    }) {
                        Text("Sign Up")
                            .font(.subheadline.bold())
                            .foregroundStyle(AppTheme.accent)
                    }
                }
                .padding(.bottom, 32)
            }
        }
    }
    
    private var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        !password.isEmpty
    }
    
    private func completeLogin() {
        withAnimation(.spring()) {
            appState.isLoggedIn = true
        }
    }
}

// Reusable auth fields styled for this app
struct AuthTextField: View {
    let title: String
    @Binding var text: String
    var icon: String? = nil
    var keyboard: UIKeyboardType = .default
    
    var body: some View {
        HStack(spacing: 12) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(width: 20)
            }
            
            TextField(title, text: $text)
                .keyboardType(keyboard)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .foregroundStyle(.white)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.card)
        )
    }
}

struct SecureAuthField: View {
    let title: String
    @Binding var text: String
    @Binding var isVisible: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lock.fill")
                .foregroundStyle(.white.opacity(0.6))
                .frame(width: 20)
            
            if isVisible {
                TextField(title, text: $text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .foregroundStyle(.white)
            } else {
                SecureField(title, text: $text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .foregroundStyle(.white)
            }
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isVisible.toggle()
                }
            }) {
                Image(systemName: isVisible ? "eye.slash.fill" : "eye.fill")
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(width: 20)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.card)
        )
    }
}

// MARK: - 3B. SAMPLE DATA MODELS

struct SleepDay: Identifiable {
    let id = UUID()
    let label: String       // e.g. "Mon"
    let hours: Double       // e.g. 7.5
    let quality: String     // e.g. "Good"
}

extension SleepDay {
    static let sampleWeek: [SleepDay] = [
        SleepDay(label: "Mon", hours: 7.5, quality: "Good"),
        SleepDay(label: "Tue", hours: 6.8, quality: "Okay"),
        SleepDay(label: "Wed", hours: 8.2, quality: "Great"),
        SleepDay(label: "Thu", hours: 5.9, quality: "Poor"),
        SleepDay(label: "Fri", hours: 7.0, quality: "Good"),
        SleepDay(label: "Sat", hours: 8.5, quality: "Great"),
        SleepDay(label: "Sun", hours: 7.3, quality: "Good")
    ]
}

// MARK: - 4. ONBOARDING ORCHESTRATOR (Manages the Sequence)
struct OnboardingOrchestrator: View {
    @EnvironmentObject var appState: AppState
    
    // The Steps
    enum Step {
        case ageGroup
        case spiritAnimal
        case goal
        case durationSetup // The "Jump" screen
        case satisfaction
        case challenges
    }
    
    @State private var currentStep: Step = .ageGroup
    @State private var transitionEdge: Edge = .trailing
    @State private var satisfactionSelection: String = ""
    @State private var challengesSelection: String = ""
    
    var body: some View {
        ZStack {
            AppTheme.gradient.ignoresSafeArea()
            
            // Step Switcher
            Group {
                switch currentStep {
                case .ageGroup:
                    QuestionScreen(
                        title: "Which age group do you\nfall into?",
                        options: [
                            "13–17",
                            "18–25",
                            "26–35",
                            "36–50",
                            "51–65"
                        ],
                        selection: $appState.ageGroup
                    ) {
                        navigate(to: .spiritAnimal)
                    }
                case .spiritAnimal:
                    SpiritAnimalScreen {
                        navigate(to: .goal)
                    }
                case .goal:
                    QuestionScreen(
                        title: "What is your\nsleep goal?",
                        options: [
                            "Maintaining uninterrupted sleep",
                            "Increasing my sleep duration", // Trigger
                            "Falling asleep faster",        // Trigger
                            "Waking up earlier"
                        ],
                        selection: $appState.sleepGoal
                    ) {
                        handleGoalSelection()
                    }
                case .durationSetup:
                    SleepDurationScreen(hours: $appState.targetHours) {
                        navigate(to: .satisfaction)
                    }
                case .satisfaction:
                    SatisfactionQuestionScreen(selection: $satisfactionSelection) {
                        navigate(to: .challenges)
                    }
                case .challenges:
                    ChallengesQuestionScreen(selection: $challengesSelection) {
                        finishOnboarding()
                    }
                }
            }
            .transition(.asymmetric(
                insertion: .move(edge: transitionEdge),
                removal: .move(edge: transitionEdge == .trailing ? .leading : .trailing)
            ))
        }
    }
    
    // Navigation Logic
    func navigate(to step: Step) {
        transitionEdge = .trailing
        withAnimation { currentStep = step }
    }
    
    func handleGoalSelection() {
        // The Jump Logic
        if appState.sleepGoal == "Increasing my sleep duration" || appState.sleepGoal == "Falling asleep faster" {
            navigate(to: .durationSetup)
        } else {
            navigate(to: .satisfaction)
        }
    }
    
    func finishOnboarding() {
        withAnimation { appState.isOnboardingDone = true }
    }
}

// MARK: - 5. ONBOARDING SCREENS

// A. Spirit Animal (First Screen)
struct SpiritAnimalScreen: View {
    @EnvironmentObject var appState: AppState
    var onContinue: () -> Void
    @State private var selectedAnimal = "pawprint.fill"
    
    let animals = [
        ("pawprint.fill", "Panda"), ("bird.fill", "Owl"), ("hare.fill", "Bunny")
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            Text("Choose Your\nSpirit Animal")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
            
            HStack(spacing: 20) {
                ForEach(animals, id: \.0) { item in
                    Button(action: {
                        withAnimation { selectedAnimal = item.0 }
                    }) {
                        VStack {
                            Image(systemName: item.0).font(.system(size: 40))
                            Text(item.1).font(.caption.bold())
                        }
                        .foregroundStyle(selectedAnimal == item.0 ? .white : .white.opacity(0.5))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selectedAnimal == item.0 ? AppTheme.accent : Color.white.opacity(0.1))
                        )
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                appState.spiritAnimal = selectedAnimal
                onContinue()
            }) {
                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundStyle(.black)
                    .clipShape(Capsule())
            }
            .padding(40)
        }
    }
}

// B. Generic Question Screen
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

// Satisfaction screen with emoji cards
struct SatisfactionQuestionScreen: View {
    @Binding var selection: String
    var onContinue: () -> Void
    
    private let options: [(label: String, emoji: String)] = [
        ("Very satisfied", "😴"),
        ("Somewhat satisfied", "🙂"),
        ("Somewhat unsatisfied", "😕"),
        ("Very unsatisfied", "😣")
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("How satisfied are you\nwith your sleep?")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
            
            VStack(spacing: 14) {
                ForEach(options, id: \.label) { item in
                    Button(action: { selection = item.label }) {
                        HStack(spacing: 14) {
                            Text(item.emoji)
                                .font(.system(size: 28))
                            Text(item.label)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selection == item.label ? Color.white.opacity(0.2) : AppTheme.card)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(selection == item.label ? AppTheme.accent : Color.white.opacity(0.2), lineWidth: 1)
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

// Challenges screen with pill chips
struct ChallengesQuestionScreen: View {
    @Binding var selection: String
    var onContinue: () -> Void
    
    private let options: [(label: String, icon: String)] = [
        ("Trouble falling asleep", "moon.zzz.fill"),
        ("Busy mind", "brain.head.profile"),
        ("Inconsistent schedule", "deskclock.fill"),
        ("Stress relief", "bolt.heart"),
        ("Noise sensitivity", "speaker.wave.3.fill")
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("What's keeping\nyou up?")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(options, id: \.label) { item in
                    Button(action: { selection = item.label }) {
                        HStack(spacing: 12) {
                            Image(systemName: item.icon)
                                .font(.subheadline)
                            Text(item.label)
                                .font(.headline)
                            Spacer()
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 14)
                        .background(selection == item.label ? AppTheme.accent.opacity(0.3) : AppTheme.card)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(selection == item.label ? AppTheme.accent : Color.white.opacity(0.2), lineWidth: 1)
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

// C. Sleep Duration (Constrained 6-12h)
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

// MARK: - 6. MAIN TAB VIEW (Home / Music / Meditate / Results / Profile)
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

// Home tab content (pre‑ritual options, goal, etc.)
struct HomeDashboardView: View {
    @EnvironmentObject var appState: AppState
    @Binding var showPaywall: Bool
    @Binding var showLogoutConfirmation: Bool
    
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
                        // Pre‑ritual options
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
                                ZStack {
                                    Circle().fill(AppTheme.accent.opacity(0.3)).frame(width: 120, height: 120)
                                    Image(systemName: appState.spiritAnimal)
                                        .font(.system(size: 50))
                                        .foregroundStyle(.white)
                                }
                                HStack {
                                    Image(systemName: appState.isSubscribed ? "play.fill" : "lock.fill")
                                    Text(appState.isSubscribed ? "Start Sleep Ritual" : "Unlock Ritual")
                                }
                                .font(.headline).foregroundStyle(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 30)
                            .background(AppTheme.card)
                            .cornerRadius(30)
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

struct RitualPill: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.subheadline)
            Text(title)
                .font(.subheadline.bold())
        }
        .foregroundStyle(.white)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(AppTheme.accent.opacity(0.4))
        .clipShape(Capsule())
    }
}

// Music tab – simple list of tracks
struct MusicTabView: View {
    let tracks = [
        "Ocean Waves • 20 min",
        "Soft Piano Dreams • 15 min",
        "Forest Night • 25 min",
        "White Noise • 30 min"
    ]
    
    var body: some View {
        ZStack {
            AppTheme.gradient.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Sleep Music")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.top, 32)
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(tracks, id: \.self) { track in
                            HStack {
                                Image(systemName: "music.note.list")
                                    .font(.title2)
                                    .foregroundStyle(AppTheme.accent)
                                Text(track)
                                    .foregroundStyle(.white)
                                Spacer()
                                Image(systemName: "play.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(.white)
                            }
                            .padding()
                            .background(AppTheme.card)
                            .cornerRadius(20)
                        }
                    }
                    .padding(.vertical)
                }
                .padding(.horizontal)
            }
        }
    }
}

// Meditate / pre‑ritual tab
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
                    .padding(.top, 32)
                
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

// Simple body scan text guide
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

// Gratitude notes – simple journaling surface
struct GratitudeNotesView: View {
    @Environment(\.dismiss) var dismiss
    @State private var text: String = ""
    
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
                
                Text("Gratitude Notes")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                
                Text("Write 1–3 things you’re grateful for today.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.horizontal)
                
                TextEditor(text: $text)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 200)
                    .padding()
                    .background(AppTheme.card)
                    .cornerRadius(20)
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Text("Save & Close")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.accent)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 24)
            }
        }
    }
}

// Simple stretching list
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


// Results tab – uses 7‑day mock data
struct ResultsTabView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            AppTheme.gradient.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Last 7 Nights")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.top, 32)
                
                Text("Mock data for now – real tracking can plug in here later.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.horizontal)
                
                List {
                    ForEach(appState.lastSevenDays) { day in
                        HStack {
                            Text(day.label)
                                .font(.headline)
                                .frame(width: 40, alignment: .leading)
                                .foregroundStyle(.white)
                            
                            GeometryReader { geo in
                                let maxWidth = geo.size.width
                                let normalized = min(day.hours / 9.0, 1.0)
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(AppTheme.card)
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(AppTheme.accent)
                                        .frame(width: maxWidth * normalized)
                                }
                            }
                            .frame(height: 16)
                            
                            VStack(alignment: .trailing, spacing: 2) {
                                Text(String(format: "%.1fh", day.hours))
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.white)
                                Text(day.quality)
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
    }
}

// Profile tab
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

// MARK: - 7. PAYWALL
struct SubscriptionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 30) {
                Spacer()
                Image(systemName: "crown.fill").font(.system(size: 80)).foregroundStyle(.yellow)
                Text("Unlock Premium").font(.largeTitle.bold()).foregroundStyle(.white)
                Button(action: {
                    appState.isSubscribed = true
                    dismiss()
                }) {
                    Text("Subscribe")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.accent)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
                .padding(.horizontal)
                Spacer()
            }
        }
    }
}
