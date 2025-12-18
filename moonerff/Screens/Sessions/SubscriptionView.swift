import SwiftUI

// MARK: - Subscription / Paywall View
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


