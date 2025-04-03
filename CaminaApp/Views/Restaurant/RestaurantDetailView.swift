import SwiftUI
import MapKit

struct RestaurantDetailView: View {
    @State private var selectedLocation = "Walk"
    let restaurant: Restaurants
    let userLocation: CLLocationCoordinate2D
    let locations = ["Walk", "Bike"]

    var distanceInKm: Double {
        let userLoc = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let restLoc = CLLocation(latitude: restaurant.location.latitude, longitude: restaurant.location.longitude)
        return userLoc.distance(from: restLoc) / 1000.0
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Image("restaurant1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .clipped()
                        .cornerRadius(12)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(restaurant.name)
                            .font(.largeTitle.bold())
                            .foregroundColor(.primaryGreen)

                        Text(restaurant.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("How to go?")
                            .font(.title2.bold())
                            .foregroundColor(.primaryGreen)

                        Picker("Choose a Spot", selection: $selectedLocation) {
                            Text("🚶‍♂️ Walk").tag("Walk")
                            Text("🚴‍♀️ Bike").tag("Bike")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.vertical, 16)
                        .padding(.horizontal, 8)
                        .frame(height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .primaryGreen.opacity(0.1), radius: 4, x: 0, y: 2)

                        // ✅ Reemplazamos el estado con un NavigationLink directo
                        NavigationLink(destination: TripInProgressView(menu: restaurant.menu, destinationName: restaurant.name)) {
                            HStack {
                                Image(systemName: "location.circle.fill")
                                    .foregroundColor(.white)
                                Text("Start")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 40)
                            .background(Color.primaryGreen)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading) {
                        Text("Location")
                            .font(.title2.bold())
                            .foregroundColor(.primaryGreen)
                            .padding(.leading, 18)

                        MapMultiplePointsView(restaurants: [restaurant], userLocation: userLocation)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle(restaurant.name)
            .accentColor(.primaryGreen)
        }
    }
}

// Ejemplo de modelos necesarios
struct Restaurants: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let image: Image
    let location: CLLocationCoordinate2D
    let menu: [Dish]
    let visitedBy: [AppUser]
    let reviews: [Review]
}

struct Dish: Identifiable {
    let id = UUID()
    let name: String
    let calories: Int
    let price: Double
}

struct AppUser: Identifiable {
    let id = UUID()
    let name: String
    let profilePicture: Image
}

struct Review: Identifiable {
    let id = UUID()
    let username: String
    let rating: Int
    let comment: String
}

#Preview {
    let sampleRestaurant = Restaurants(
        name: "Casa Cholula",
        description: "Traditional Mexican food with a modern twist.",
        image: Image(systemName: "photo"),
        location: CLLocationCoordinate2D(latitude: 19.0640, longitude: -98.3036),
        menu: [
            Dish(name: "Tacos al Pastor", calories: 450, price: 14.99),
            Dish(name: "Chiles en Nogada", calories: 700, price: 169.99),
            Dish(name: "Mole Poblano", calories: 600, price: 129.99),
            Dish(name: "Sushi Roll Tempura", calories: 480, price: 189.50),
            Dish(name: "Ensalada César con Pollo", calories: 390, price: 112.00),
            Dish(name: "Hamburguesa BBQ", calories: 950, price: 149.75),
            Dish(name: "Pizza Margarita", calories: 860, price: 199.90),
            Dish(name: "Ramen Tonkotsu", calories: 820, price: 175.25),
        ],
        visitedBy: [
            AppUser(name: "Sofía", profilePicture: Image(systemName: "person.fill")),
            AppUser(name: "Luis", profilePicture: Image(systemName: "person.fill"))
        ],
        reviews: [
            Review(username: "Sofía", rating: 5, comment: "Amazing food!"),
            Review(username: "Luis", rating: 4, comment: "Loved the mole.")
        ]
    )
    let sampleUserLocation = CLLocationCoordinate2D(latitude: 19.0580, longitude: -98.2970)

    return RestaurantDetailView(restaurant: sampleRestaurant, userLocation: sampleUserLocation)
}
