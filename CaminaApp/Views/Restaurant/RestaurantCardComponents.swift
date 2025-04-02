import SwiftUI

struct CalorieComparisonView: View {
    let percentage: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 8)
                .opacity(0.3)
                .foregroundColor(.white)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(percentage, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                .foregroundColor(percentage >= 1.0 ? .green : .primaryGreen)
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeOut, value: percentage)
            
            VStack {
                Text("\(Int(percentage * 100))%")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                Text("quemado")
                    .font(.system(size: 8))
                    .foregroundColor(.white)
            }
        }
    }
}

struct NutritionBadge: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack {
            Text(value)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(6)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}
