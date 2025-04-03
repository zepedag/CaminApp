import SwiftUI
import CoreLocation

struct RestaurantCardView: View {
    let restaurant: Restaurant

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            backgroundImage
            overlayContent
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 4)
    }

    private var backgroundImage: some View {
        Image("antojitos-image") // Reemplaza con la imagen real
            .resizable()
            .scaledToFill()
            .frame(height: 180) // Altura mejorada
            .clipped()
            .overlay(Color.black.opacity(0.4)) // Oscurece para mejorar el contraste
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
        .padding(12)
    }

    private var calorieCircle: some View {
        CalorieComparisonView(percentage: restaurant.caloriesPercentage)
            .frame(width: 70, height: 70) // Tamaño más equilibrado
            .padding(.trailing, 10)
    }
}

struct RestaurantCardView_Previews: PreviewProvider {
    static var previewProvider: Restaurant {
        Restaurant(
            id: UUID(),
            name: "Healthy Burgers",
            foodType: "Burgers",
            distance: 1.5,
            walkingTime: 15,
            caloriesInFood: 500,
            coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)
        )
    }

    static var previews: some View {
        RestaurantCardView(restaurant: previewProvider)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
