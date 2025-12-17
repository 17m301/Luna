import SwiftUI

// MARK: - Results Tab View
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

