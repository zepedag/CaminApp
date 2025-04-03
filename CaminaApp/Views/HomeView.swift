import SwiftUI
import MapKit
import CoreLocation
import Firebase
import FirebaseAuth

// MARK: - Modelo para los restaurantes con coordenadas
struct RestaurantLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let description: String
}

// MARK: - Location Manager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.0413, longitude: -98.2062),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    private var hasSetInitialRegion = false

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        if !hasSetInitialRegion {
            DispatchQueue.main.async {
                self.region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
                self.hasSetInitialRegion = true
            }
        }
    }
    
}

// MARK: - Restaurant Detail Sheet
struct RestaurantDetailSheet: View {
    let restaurant: RestaurantLocation

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(restaurant.name)
                .font(.title2)
                .bold()

            Text(restaurant.description)
                .font(.body)

            Spacer()
        }
        .padding()
        .presentationDetents([.fraction(0.3), .medium])
    }
}

// MARK: - HomeView
struct HomeView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var isShowingNotification = false
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var selectedRestaurant: RestaurantLocation? = nil
    @State private var showingDetailSheet = false
    @State private var isShowingSearchResults = false
    @State private var selectedRestaurantDetail: Restaurants? = nil
    @State private var region: MKCoordinateRegion
    @State private var isExpanded = false
    
    let restaurants: [Restaurants]
    let userLocation: CLLocationCoordinate2D
    
    @State private var userName: String = "Hi"

    let nearbyRestaurants = [
        RestaurantLocation(
            name: "Santoua",
            coordinate: CLLocationCoordinate2D(latitude: 19.0418, longitude: -98.2055),
            description: "Contemporary Japanese restaurant with sushi and ramen."
        ),
        RestaurantLocation(
            name: "Cus Cus Cus",
            coordinate: CLLocationCoordinate2D(latitude: 19.0420, longitude: -98.2070),
            description: "Comida árabe y mediterránea en un ambiente acogedor."
        ),
        RestaurantLocation(
            name: "La Textilería",
            coordinate: CLLocationCoordinate2D(latitude: 19.0412, longitude: -98.2093),
            description: "Espacio moderno con cocina de autor y brunch de fin de semana."
        ),
        RestaurantLocation(
            name: "Central de Agaves",
            coordinate: CLLocationCoordinate2D(latitude: 19.0426, longitude: -98.2060),
            description: "Restaurante mexicano con cocteles artesanales y platillos tradicionales."
        ),
        RestaurantLocation(
            name: "Sushi Seven",
            coordinate: CLLocationCoordinate2D(latitude: 19.0431, longitude: -98.2048),
            description: "Fusión japonesa con opciones de sushi, ramen y teppanyaki."
        ),
        RestaurantLocation(
            name: "Café & Tocino",
            coordinate: CLLocationCoordinate2D(latitude: 19.0424, longitude: -98.2087),
            description: "Desayunos todo el día, café artesanal y pan recién horneado."
        ),
        RestaurantLocation(
            name: "La Casa del Chef",
            coordinate: CLLocationCoordinate2D(latitude: 19.0435, longitude: -98.2059),
            description: "Cocina internacional con enfoque en ingredientes locales."
        ),
        RestaurantLocation(
            name: "Tacos Don Pancho",
            coordinate: CLLocationCoordinate2D(latitude: 19.0416, longitude: -98.2068),
            description: "Tacos tradicionales al pastor y aguas frescas caseras."
        )
    ]



    
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
        
        NavigationView {
            ScrollView {
                NavigationLink(destination: NotificationView(), isActive: $isShowingNotification) { EmptyView() }
                NavigationLink(
                                   destination: HealthyCravingSearchView(initialSearchText: searchText),
                                   isActive: $isShowingSearchResults
                               ) { EmptyView() }

                HStack {
                    VStack(alignment: .leading) {
                        Text("Hi, \(userName)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.top, 15)
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 10) {
                    TextField("Let's eat...", text: $searchText, onCommit: {
                        if !searchText.isEmpty {
                            isShowingSearchResults = true
                        }
                    })
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            HStack {
                                Spacer()
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 10)
                            }
                        )

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(["All", "Hamburguers", "Tacos", "Sushi", "Coffee"], id: \ .self) { category in
                                Button(action: {
                                    selectedCategory = category
                                }) {
                                    Text(category)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(selectedCategory == category ? Color.primaryGreen : Color(.systemGray5))
                                        .foregroundColor(selectedCategory == category ? .white : .black)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 10)
                }
                .padding(.horizontal)
                .padding()

                WeeklyActivitySummaryView()
                PopularNearbyView()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Explore nearby places")
                        .font(.headline)
                        .foregroundColor(.primaryGreen)
                        .padding(.top, 16)
                        .padding(.horizontal)
 
                    ZStack(alignment: .bottomTrailing) {
                        // Map with annotations
                        Map(coordinateRegion: $locationManager.region, annotationItems: nearbyRestaurants) { restaurant in
                            MapAnnotation(coordinate: restaurant.coordinate) {
                                Button(action: {
                                    // Simulación: conviertes el RestaurantLocation en un Restaurants real
                                    selectedRestaurantDetail = Restaurants(
                                        name: restaurant.name,
                                        description: restaurant.description,
                                        image: Image("restaurant2"),
                                        location: restaurant.coordinate,
                                        menu: [Dish(name: "Tacos al Pastor", calories: 450, price: 14.99)], // ejemplo
                                        visitedBy: [],
                                        reviews: []
                                    )
                                    showingDetailSheet = true
                                }) {
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
                                .sheet(isPresented: $showingDetailSheet) {
                                    if let detailRestaurant = selectedRestaurantDetail {
                                        RestaurantDetailView(restaurant: detailRestaurant, userLocation: locationManager.region.center)
                                    }
                                }
                                
                            }
                        }
                        .frame(height: 200)
                        .cornerRadius(12)
                    
                        VStack(spacing: 12) {
                            MapControlButton2(icon: "plus") {
                                locationManager.region.span.latitudeDelta /= 1.5
                                locationManager.region.span.longitudeDelta /= 1.5
                            }

                            MapControlButton2(icon: "minus") {
                                locationManager.region.span.latitudeDelta *= 1.5
                                locationManager.region.span.longitudeDelta *= 1.5
                            }

                            MapControlButton2(icon: "arrow.up.left.and.arrow.down.right") {
                                isExpanded.toggle()
                            }

                            MapControlButton2(icon: "map.fill") {
                                openInMaps()
                            }
                        }
                        .padding(10)
                    }
                }
                .padding(.bottom)
                .sheet(item: $selectedRestaurant) { restaurant in
                    RestaurantDetailSheet(restaurant: restaurant)
                }
                .navigationTitle("Home")
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(trailing: Button(action: {
                    isShowingNotification = true
                }) {
                    Image(systemName: "bell.badge.fill")
                })
            }
        }
        .navigationBarBackButtonHidden(true)
        .accentColor(Color.primaryGreen)
        .onAppear {
            fetchUserNameFromDatabase()
        }
    }

    private func fetchUserNameFromDatabase() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No identified user")
            userName = "there"
            return
        }

        print("Searching user by ID: \(userID)")

        let dbRef = Database.database().reference()
        dbRef.child("users").child(userID).observeSingleEvent(of: .value) { snapshot in
            print("Snapshot received: \(snapshot)")

            if let userData = snapshot.value as? [String: Any] {
                print("User data: \(userData)")
                self.userName = userData["firstName"] as? String ?? "there"
            } else {
                print("User data not found")
                self.userName = "there"
            }
        }
    }
    
    func openInMaps() {
        guard let first = restaurants.first else { return }
        let placemark = MKPlacemark(coordinate: first.location)
        let item = MKMapItem(placemark: placemark)
        item.name = first.name
        item.openInMaps()
    }
}

struct MapControlButton2: View {
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


// MARK: - PopularNearbyView
struct PopularNearbyView: View {
    struct Restaurant: Identifiable {
        let id = UUID()
        let image: Image
        let name: String
        let distance: String
        let calories: String
    }

    let restaurants: [Restaurant] = [
        Restaurant(image: Image("restaurant1"), name: "Santoua", distance: "12 min", calories: "450 kcal"),
        Restaurant(image: Image("restaurant2"), name: "Cus Cus Cus", distance: "8 min", calories: "520 kcal"),
        Restaurant(image: Image("restaurant3"), name: "Green Garden", distance: "18 min", calories: "370 kcal"),
        Restaurant(image: Image("restaurant4"), name: "Pizza Urbana", distance: "21 mn", calories: "900 kcal"),
        Restaurant(image: Image("restaurant5"), name: "Ramen House", distance: "9 min", calories: "610 kcal")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Populares cerca de ti")
                .font(.title3.bold())
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(restaurants) { restaurant in
                        VStack(alignment: .leading, spacing: 6) {
                            restaurant.image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 180, height: 140)
                                .clipped()
                                .cornerRadius(16)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(restaurant.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                HStack(spacing: 15) {
                                    Label(restaurant.distance, systemImage: "clock.fill")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    Label(restaurant.calories, systemImage: "flame.fill")
                                        .font(.caption)
                                        .foregroundColor(.primaryGreen.opacity(0.6))
                                }
                            }
                            .padding(.horizontal, 4)
                        }
                        .frame(width: 180)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 8)
    }
}


// MARK: - WeeklyActivitySummaryView
struct WeeklyActivitySummaryView: View {
    @State private var navigateToDetail = false

    var body: some View {
        Button(action: {
            navigateToDetail = true
        }) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.primaryGreen.opacity(0.8), Color.navyBlue.opacity(0.85)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .cornerRadius(20)

                HStack {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("This Week's Activity")
                            .font(.title3.bold())
                            .foregroundColor(.white)

                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                CircleIcon(symbol: "figure.walk", color: .white.opacity(0.2))
                                Text("8,420 steps")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                            }

                            HStack {
                                CircleIcon(symbol: "ruler", color: .white.opacity(0.2))
                                Text("5.7 km")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                            }

                            HStack {
                                CircleIcon(symbol: "flame.fill", color: .white.opacity(0.2))
                                Text("388 kcal")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                            }
                        }
                    }

                    Spacer()

                    ZStack {
                        Circle()
                            .stroke(lineWidth: 10)
                            .opacity(0.2)
                            .foregroundColor(.white)

                        Circle()
                            .trim(from: 0.0, to: 0.65)
                            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .foregroundColor(.white)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeOut(duration: 1.0), value: 0.65)

                        Text("65%")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .frame(width: 70, height: 70)
                }
                .padding(20)
            }
        }
        .frame(width: 351, height: 165)
        .background(
            NavigationLink(destination: WeeklyActivityDetailView(), isActive: $navigateToDetail) {
                EmptyView()
            }
        )
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
}

// Reusable icon in circle
struct CircleIcon: View {
    let symbol: String
    let color: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: 28, height: 28)

            Image(systemName: symbol)
                .font(.system(size: 14, weight: .semibold)) // Estilo consistente
                .foregroundColor(.white)
                .frame(width: 18, height: 18) // Forzar íconos del mismo tamaño
        }
    }
}



// MARK: - WeeklyActivityDetailView
struct WeeklyActivityDetailView: View {
    var body: some View {
        Text("Detalle de la actividad semanal")
            .font(.title)
            .padding()
    }
}


// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
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

        return HomeView(restaurants: sampleRestaurants, userLocation: userLocation)
            .navigationBarBackButtonHidden(true)
    }
}
