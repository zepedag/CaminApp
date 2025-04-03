import SwiftUI
import MapKit

struct TripSummaryView: View {
    var restaurantName: String = "Santoua"
    @State private var isShowingHome = false
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "trophy.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 70)
                .foregroundColor(.primaryGreen)
                
            Text("Trip Summary")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Text("Destination: \(restaurantName)")
                .font(.title3)
                .foregroundColor(.brown)
                
            Image("ruta")
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 170)
                .cornerRadius(10)
                .shadow(radius: 5)

                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "map.fill")
                            .foregroundColor(.primaryGreen)
                        Text("Distance: 2.5 km")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.primaryGreen)
                        Text("Calories burned: 150 kcal")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.primaryGreen)
                        Text("Time: 21 min")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                }
            .padding()
            
            Button(action: {
                shareTrip()
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share with friends")
                        .fontWeight(.bold)
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.primaryGreen)
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding(.horizontal)
            }
            Button(action: {
                isShowingHome = true
            }) {
                HStack {
                    Image(systemName: "xmark.circle.fill")
                    Text("Exit")
                        .fontWeight(.bold)
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.brown)
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding(.horizontal)
            }
            .navigationDestination(isPresented: $isShowingHome) {
                let sampleRestaurants = [
                    Restaurants(
                        name: "Casa Cholula",
                        description: "Traditional Mexican food with a modern twist.",
                        image: Image(systemName: "photo"),
                        location: CLLocationCoordinate2D(latitude: 19.0640, longitude: -98.3036),
                        menu: [Dish(name: "Tacos al Pastor", calories: 450, price: 49.99)],
                        visitedBy: [],
                        reviews: []
                    )
                ]
                let userLocation = CLLocationCoordinate2D(latitude: 19.0625, longitude: -98.3040)
                
                HomeView(restaurants: sampleRestaurants, userLocation: userLocation)
            }
        }
        
        .padding()
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .navigationTitle("Trip Stats")
        .accentColor(Color.primaryGreen)
    }
    func shareTrip() {
        // Implementar funcionalidad de compartir
    }
}

#Preview {
    TripSummaryView()
}
