import SwiftUI
import CoreLocation

struct RestaurantCardView: View {
    let restaurant: Restaurant
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                restaurantInfo
                Spacer()
                calorieCircle
            }
            
            nutritionInfo
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var restaurantInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(restaurant.name)
                .font(.headline)
            
            Text(restaurant.foodType)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 16) {
                Label("\(restaurant.distance.formatted(.number.precision(.fractionLength(1)))) km", systemImage: "map")
                Label("\(restaurant.walkingTime) min", systemImage: "clock")
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
    }
    
    private var calorieCircle: some View {
        CalorieComparisonView(percentage: restaurant.caloriesPercentage)
            .frame(width: 60, height: 60)
    }
    
    private var nutritionInfo: some View {
        HStack {
            NutritionBadge(value: "\(restaurant.caloriesInFood) kcal", label: "Comida", color: .orange)
            NutritionBadge(value: "\(restaurant.caloriesBurned) kcal", label: "Quemadas", color: .primaryGreen)
            NutritionBadge(value: "\(Int((1 - restaurant.caloriesPercentage) * 100))%", label: "Neto", color: .purple)
        }
    }
}

struct RestaurantCardView_Previews: PreviewProvider {
    static var previewProvider: Restaurant {
        Restaurant(
            id: UUID(),
            name: "Ejemplo Restaurante",
            foodType: "Comida Mexicana",
            distance: 1.5,
            walkingTime: 15,
            caloriesInFood: 500,
            coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)
        )
    }
    
    static var previews: some View {
        RestaurantCardView(restaurant: previewProvider)
            .previewLayout(.sizeThatFits)
    }
}
