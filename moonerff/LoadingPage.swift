//
//  ContentView.swift
//  FoundationApp
//
//  Created by AFP FED 26 on 04/12/25.
//

import SwiftUI
import SwiftData
import Charts
import Combine

struct LoadingPage: View {
    var onComplete: () -> Void
    
    @State private var scale = 0.8
    @State private var opacity = 0.0
    
    var body: some View {
       
        ZStack{
            Color.black.ignoresSafeArea()
            VStack {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400)
                    .foregroundStyle(.linearGradient(colors: [.cyan, .purple], startPoint: .top, endPoint: .bottom))
                
            }
            .scaleEffect(scale)
            .opacity(opacity)
            
        }  .onAppear {
            withAnimation(.easeOut(duration: 1.5)) {
                scale = 1.0
                opacity = 1.0
            }
            // Auto-advance after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                onComplete()
            }
        }

    }
}

#Preview {
    LoadingPage(onComplete: {})
}
