import SwiftUI
import CoreLocation

struct RestaurantCardView: View {
    let restaurant: Restaurant
    var userLocation: CLLocationCoordinate2D? = nil
    @State private var isShowingRestDetail = false
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            backgroundImage
            overlayContent
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 4)
    }

    private var backgroundImage: some View {
        Button(action: {
            isShowingRestDetail = true
        }) {
            Image("antojitos-image") // Reemplaza con la imagen real
                .resizable()
                .scaledToFill()
                .frame(height: 180) // Altura mejorada
                .clipped()
                .overlay(Color.black.opacity(0.4)) // Oscurece para mejorar el contraste
        }
    }

    private var overlayContent: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(restaurant.name)
                .font(.headline)
                .foregroundColor(.white)
                .bold()
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            HStack {
                Label(restaurant.foodType, systemImage: "fork.knife")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(6)
                    .background(Color.white.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                Spacer()

                calorieCircle
            }

            Label("\(restaurant.walkingTime) min", systemImage: "clock")
                .font(.caption)
                .foregroundColor(.white)
                .padding(6)
                .background(Color.white.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .navigationDestination(isPresented: $isShowingRestDetail) {
            RestaurantCardView(restaurant: restaurant)
        }
        .padding(12)
    }

    private var calorieCircle: some View {
        CalorieComparisonView(percentage: restaurant.caloriesPercentage)
            .frame(width: 70, height: 70) // Tamaño más equilibrado
            .padding(.trailing, 10)
    }
}
