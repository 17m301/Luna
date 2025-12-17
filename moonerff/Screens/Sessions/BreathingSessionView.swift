import SwiftUI
import AVFoundation

// MARK: - Breathing Session View
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
        .onAppear { startBreathingLoop(); playMusic() }
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

