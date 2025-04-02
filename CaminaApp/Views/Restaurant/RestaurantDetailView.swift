import SwiftUI
import MapKit

struct RestaurantDetailView: View {
    let restaurant: Restaurant
    let userLocation: CLLocationCoordinate2D

    var distanceInKm: Double {
        let userLoc = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let restLoc = CLLocation(latitude: restaurant.location.latitude, longitude: restaurant.location.longitude)
        return userLoc.distance(from: restLoc) / 1000.0
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Imagen del restaurante
                Image("restaurant1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .clipped()
                    .cornerRadius(12)

                // Nombre y descripción
                VStack(alignment: .leading, spacing: 6) {
                    Text(restaurant.name)
                        .font(.largeTitle.bold())
                        .foregroundColor(.primaryGreen)

                    Text(restaurant.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)

                // Menú con calorías en scroll horizontal en tarjetas cuadradas
                VStack(alignment: .leading, spacing: 10) {
                    Text("Menu")
                        .font(.title2.bold())
                        .foregroundColor(.primaryGreen)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(restaurant.menu) { dish in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(dish.name)
                                        .font(.headline)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(2)
                                        .foregroundColor(.primary)

                                    Text("\(dish.calories) kcal")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    Text("$\(String(format: "%.2f", dish.price)) MXN")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    HStack {
                                        Spacer()
                                        Image(systemName: "leaf")
                                            .foregroundColor(.primaryGreen)
                                    }
                                }
                                .padding()
                                .frame(width: 140, height: 140)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(.horizontal)

                // Mapa
                VStack(alignment: .leading) {
                    Text("Location")
                        .font(.title2.bold())
                        .foregroundColor(.primaryGreen)

                    Map(coordinateRegion: .constant(
                        MKCoordinateRegion(
                            center: restaurant.location,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    ), annotationItems: [restaurant]) { place in
                        MapMarker(coordinate: place.location, tint: .primaryGreen)
                    }
                    .frame(height: 200)
                    .cornerRadius(12)
                }
                .padding(.horizontal)

                // Información de distancia y calorías
                VStack(alignment: .leading, spacing: 6) {
                    Text("Distance: \(String(format: "%.2f", distanceInKm)) km")
                        .font(.subheadline)
                    Text("Walking: \(String(format: "%.0f", distanceInKm * 50)) kcal")
                    Text("Biking: \(String(format: "%.0f", distanceInKm * 30)) kcal")
                }
                .padding(.horizontal)
                .foregroundColor(.gray)

                // Amigos que lo visitaron
                VStack(alignment: .leading, spacing: 6) {
                    Text("Friends who visited")
                        .font(.title2.bold())
                        .foregroundColor(.primaryGreen)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(restaurant.visitedBy, id: \ .id) { friend in
                                VStack(spacing: 4) {
                                    friend.profilePicture
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())

                                    Text(friend.name)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)

                // Reviews
                VStack(alignment: .leading, spacing: 10) {
                    Text("Reviews")
                        .font(.title2.bold())
                        .foregroundColor(.primaryGreen)

                    ForEach(restaurant.reviews) { review in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(review.username)
                                    .font(.subheadline.bold())
                                Spacer()
                                Text("⭐️ \(review.rating)/5")
                            }
                            Text(review.comment)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(restaurant.name)
        .accentColor(.primaryGreen)
    }
}

// Ejemplo de modelos necesarios
struct Restaurant: Identifiable {
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
    let sampleRestaurant = Restaurant(
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
