import SwiftUI

// MARK: - Music Tab View
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
                    .padding(.top, 32).padding(.horizontal)
                
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

#Preview {
    MusicTabView()
}

