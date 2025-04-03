import SwiftUI

struct FitnessFactsCarousel: View {
    let facts: [String]
    @State private var currentIndex = 0
    @State private var timer: Timer?
    @State private var currentColorIndex = 0
    
    // Configuration
    private let rotationInterval: TimeInterval = 7.0
    private let animationDuration: Double = 0.5
    private let colors: [Color] = [
        Color(red: 0.95, green: 0.85, blue: 0.8),   // Soft peach
        Color(red: 0.85, green: 0.95, blue: 0.85),   // Mint green
        Color(red: 0.85, green: 0.85, blue: 0.95),    // Lavender
        Color(red: 0.95, green: 0.95, blue: 0.85)     // Light yellow
    ]
    
    var body: some View {
        HStack(spacing: 12) {
            // Lightbulb icon
            Image(systemName: "lightbulb.fill")
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(Circle().fill(colors[currentColorIndex].opacity(0.8)))
                .padding(.leading, 12)
            
            // Fact text
            Text("Did you know: \(facts[currentIndex])")
                .font(.subheadline)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 12)
        }
        .padding(.vertical, 10)
        .background(colors[currentColorIndex].opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal)
        .onAppear { startTimer() }
        .onDisappear { stopTimer() }
        .animation(.easeInOut(duration: animationDuration), value: currentIndex)
        .animation(.easeInOut(duration: animationDuration), value: currentColorIndex)
    }
    
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: rotationInterval, repeats: true) { _ in
            currentIndex = (currentIndex + 1) % facts.count
            currentColorIndex = (currentColorIndex + 1) % colors.count
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

extension FitnessFactsCarousel {
    static var defaultFacts: [String] {
        [
            "Regular exercise boosts brain function and memory",
            "Morning workouts can help regulate your sleep cycle",
            "Stretching improves flexibility and blood circulation",
            "Strength training helps prevent age-related muscle loss",
            "Walking in nature reduces stress levels significantly",
            "Short exercise breaks improve work productivity",
            "Consistent workouts strengthen your immune system"
        ]
    }
}

struct FitnessFactsCarousel_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            FitnessFactsCarousel(facts: FitnessFactsCarousel.defaultFacts)
            Spacer()
        }
        .previewLayout(.sizeThatFits)
    }
}

#Preview {
    FitnessFactsCarousel(facts: FitnessFactsCarousel.defaultFacts)
}
