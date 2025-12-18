import SwiftUI

// MARK: - Onboarding Orchestrator (Manages the Sequence)
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


