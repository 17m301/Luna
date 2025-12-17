import SwiftUI

// MARK: - Spirit Animal Selection Screen
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

