import SwiftUI
import AVFoundation

// MARK: - Body Scan Session View
struct MeditationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var animate = false
    @State private var isRecording: Bool = false
    @State private var audioPlayer: AVAudioPlayer?
    
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
                
                Text("Meditation")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                
                Spacer()
                HStack{
                    Spacer()
                    ZStack {
                        
                        /*Circle()
                            .fill(.white.opacity(0.08))
                            .frame(width: 260, height: 260)
                            .scaleEffect(animate ? 1.05 : 0.95)
                            .animation(
                                .easeInOut(duration: 3).repeatForever(autoreverses: true),
                                value: animate
                            )*/
                        
                        
                        /*Image(systemName: "apple.meditate.circle")
                            
                            .resizable()
                            .scaledToFill()
                            .frame(width: 220, height: 220)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(.white.opacity(0.15), lineWidth: 2)
                            )
                            .scaleEffect(animate ? 1.02 : 0.98)
                            .animation(
                                .easeInOut(duration: 3).repeatForever(autoreverses: true),
                                value: animate
                            )*/
                        Image(systemName: "apple.meditate.circle")
                            .font(.system(size: 180))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(
                                animate ? AppTheme.accent : .white,
                                animate ? AppTheme.accent.opacity(0.3) : .white.opacity(0.2)
                            )
                            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animate)
                            .onAppear { animate = true }
                    }
                    Spacer()
                }
                .onAppear {
                    animate = true
                }
                .padding(.bottom, 100)
                Spacer()
                
                HStack{
                    Spacer()
                    Text("Follow the expanding circle to breathe.")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                    Spacer()
                    
                }.padding(.bottom,20)
            }
            
            Spacer()
        }.onAppear { playMusic() }
            .onDisappear { audioPlayer?.stop() }
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
    MeditationView()
}

