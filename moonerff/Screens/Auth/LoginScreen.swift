import SwiftUI

// MARK: - Login Screen
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

#Preview {
    LoginScreen()
}

