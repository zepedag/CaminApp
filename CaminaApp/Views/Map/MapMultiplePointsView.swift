import SwiftUI
import MapKit

struct MapMultiplePointsView: View {
    let restaurants: [Restaurants]
    let userLocation: CLLocationCoordinate2D

    var body: some View {
        let coordinates = restaurants.map { $0.location }
        let minLat = coordinates.min { $0.latitude < $1.latitude }?.latitude ?? 19.0413
        let maxLat = coordinates.max { $0.latitude < $1.latitude }?.latitude ?? 19.0413
        let minLon = coordinates.min { $0.longitude < $1.longitude }?.longitude ?? -98.2070
        let maxLon = coordinates.max { $0.longitude < $1.longitude }?.longitude ?? -98.2055

        let spanLatitudeDelta = maxLat - minLat + 0.01
        let spanLongitudeDelta = maxLon - minLon + 0.01

        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2),
            span: MKCoordinateSpan(latitudeDelta: spanLatitudeDelta, longitudeDelta: spanLongitudeDelta)
        )

        return VStack(alignment: .leading) {
            Text("Location")
                .font(.title2.bold())
                .foregroundColor(.primaryGreen)

            Map(coordinateRegion: .constant(region), annotationItems: restaurants) { restaurant in
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
        }
        .padding(.horizontal)
    }
}

struct MapMultiplePointsView_Previews: PreviewProvider {
    static var previews: some View {
        MapMultiplePointsView(
            restaurants: [
                Restaurants(
                    name: "Casa Cholula",
                    description: "Traditional Mexican food with a modern twist.",
                    image: Image(systemName: "photo"),
                    location: CLLocationCoordinate2D(latitude: 19.0640, longitude: -98.3036),
                    menu: [],
                    visitedBy: [],
                    reviews: []
                )
            ],
            userLocation: CLLocationCoordinate2D(latitude: 19.0580, longitude: -98.2970)
        )
    }
}
