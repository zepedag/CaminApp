import SwiftUI
import MapKit

struct MapMultiplePointsView: View {
    let restaurants: [Restaurants]
    let userLocation: CLLocationCoordinate2D

    @State private var region: MKCoordinateRegion
    @State private var isExpanded = false

    init(restaurants: [Restaurants], userLocation: CLLocationCoordinate2D) {
        self.restaurants = restaurants
        self.userLocation = userLocation

        let coordinates = restaurants.map { $0.location }
        let minLat = coordinates.min(by: { $0.latitude < $1.latitude })?.latitude ?? 19.0413
        let maxLat = coordinates.max(by: { $0.latitude < $1.latitude })?.latitude ?? 19.0413
        let minLon = coordinates.min(by: { $0.longitude < $1.longitude })?.longitude ?? -98.2070
        let maxLon = coordinates.max(by: { $0.longitude < $1.longitude })?.longitude ?? -98.2055

        let spanLatitudeDelta = maxLat - minLat + 0.005
        let spanLongitudeDelta = maxLon - minLon + 0.005

        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                           longitude: (minLon + maxLon) / 2),
            span: MKCoordinateSpan(latitudeDelta: spanLatitudeDelta,
                                   longitudeDelta: spanLongitudeDelta)
        ))
    }

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                Map(coordinateRegion: $region, annotationItems: restaurants) { restaurant in
                    MapAnnotation(coordinate: restaurant.location) {
                        VStack(spacing: 0) {
                            ZStack {
                                Circle()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.title)
                            }
                            Text(restaurant.name)
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                }
                .frame(height: 200)
                .cornerRadius(12)

                // Botones
                VStack(spacing: 12) {
                    MapControlButton(icon: "plus") {
                        region.span.latitudeDelta /= 1.5
                        region.span.longitudeDelta /= 1.5
                    }

                    MapControlButton(icon: "minus") {
                        region.span.latitudeDelta *= 1.5
                        region.span.longitudeDelta *= 1.5
                    }

                    MapControlButton(icon: "arrow.up.left.and.arrow.down.right") {
                        isExpanded.toggle()
                    }

                    MapControlButton(icon: "map.fill") {
                        openInMaps()
                    }
                }
                .padding(10)
            }
        }
        .sheet(isPresented: $isExpanded) {
            Map(coordinateRegion: $region, annotationItems: restaurants) { restaurant in
                MapMarker(coordinate: restaurant.location, tint: .red)
            }
            .edgesIgnoringSafeArea(.all)
        }
        .padding(.horizontal)
    }

    func openInMaps() {
        guard let first = restaurants.first else { return }
        let placemark = MKPlacemark(coordinate: first.location)
        let item = MKMapItem(placemark: placemark)
        item.name = first.name
        item.openInMaps()
    }
}

// Botón de control para mapa
struct MapControlButton: View {
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(Color.black.opacity(0.7))
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    MapMultiplePointsView(
        restaurants: [
            Restaurants(
                name: "Casa Cholula",
                description: "Comida tradicional mexicana con un toque moderno.",
                image: Image(systemName: "photo"),
                location: CLLocationCoordinate2D(latitude: 19.0640, longitude: -98.3036),
                menu: [
                    Dish(name: "Tacos al Pastor", calories: 450, price: 49.99)
                ],
                visitedBy: [],
                reviews: []
            ),
            Restaurants(
                name: "Tacos Memo",
                description: "Deliciosos tacos rápidos y baratos.",
                image: Image(systemName: "photo"),
                location: CLLocationCoordinate2D(latitude: 19.0625, longitude: -98.3010),
                menu: [],
                visitedBy: [],
                reviews: []
            )
        ],
        userLocation: CLLocationCoordinate2D(latitude: 19.0630, longitude: -98.3020)
    )
}
