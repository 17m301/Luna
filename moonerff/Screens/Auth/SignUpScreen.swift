import SwiftUI

// MARK: - Sign Up Screen
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
#Preview {
    SignUpScreen()
}

