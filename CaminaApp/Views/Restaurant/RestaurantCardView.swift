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
            .frame(height: 160)
            .clipped()
            .overlay(Color.brown.opacity(0.6))
    }
    
    private var overlayContent: some View {
        VStack(alignment: .leading, spacing: 0) {
           
            HStack {
                Text(restaurant.name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .bold()
                    .padding(.top, 5)
                    .padding(.leading, 20)
                    .background(Color.white.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            HStack() {
                VStack{
                    Label(restaurant.foodType, systemImage: "fork.knife")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(6)
                        .padding(.leading, 20)
                        .background(Color.white.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                Spacer()
                VStack{
                    calorieCircle
                        .padding(.trailing, 20)
                }
               
            }
            HStack() {
                Label("\(restaurant.walkingTime) min", systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(8)
                    .padding(.leading, 20)
                    .background(Color.white.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            
        }
        .padding()
    }

    private var calorieCircle: some View {
        CalorieComparisonView(percentage: restaurant.caloriesPercentage)
            .frame(width: 80, height: 80)
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
            .padding()
    }
}

