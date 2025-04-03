import SwiftUI

struct WalkingAnimationView: View {
    @State private var isWalking = false
    
    var body: some View {
        Image(systemName: "figure.walk")
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 150)
            .foregroundColor(.primaryGreen)
            .offset(y: isWalking ? -10 : 10)
            .animation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: isWalking)
            .onAppear {
                isWalking = true
            }
    }
}

