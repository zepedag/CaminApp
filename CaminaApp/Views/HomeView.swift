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
    
    @State private var userName: String = "Hi"
    
    let nearbyRestaurants = [
        RestaurantLocation(name: "Santoua", coordinate: CLLocationCoordinate2D(latitude: 19.0418, longitude: -98.2055), description: "Contemporary Japanese restaurant with sushi and ramen."),
        RestaurantLocation(name: "Cus Cus Cus", coordinate: CLLocationCoordinate2D(latitude: 19.0420, longitude: -98.2070), description: "Comida árabe y mediterránea en un ambiente acogedor.")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                NavigationLink(destination: NotificationView(), isActive: $isShowingNotification) { EmptyView() }
                NavigationLink(destination: HealthyCravingSearchView(initialSearchText: searchText),isActive: $isShowingSearchResults
                ){ EmptyView() }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Hi, \(userName)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.top, 15) // espacio desde la parte superior
                .padding(.horizontal) // espacio lateral

                
                VStack(alignment: .leading, spacing: 10) {
                    TextField("Let's eat...", text: $searchText)
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
                            ForEach(["All", "Hamburguers", "Tacos", "Sushi", "Coffee"], id: \.self) { category in
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
                                    VStack {
                                        Image(systemName: "mappin.circle.fill")
                                            .foregroundColor(.red)
                                            .font(.title)
                                        Text(restaurant.name)
                                            .font(.caption)
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
                        
                        
                        /*
                         Button(action: {
                         self.showingTipsSheet = true
                         }) {
                         GardenTipsView(garden: garden)
                         }
                         .sheet(isPresented: $showingTipsSheet) {
                         // Present your tips view here
                         }
                         NavigationLink(destination: GardenView(garden: garden), isActive: $showingPlantsSheet) {
                         GardenPlantsView(garden: garden)
                         }
                         
                         */
                        
                        // Zoom buttons
                        VStack {
                            HStack {
                                // Button to zoom out
                                Button(action: {
                                    let newSpan = MKCoordinateSpan(latitudeDelta: locationManager.region.span.latitudeDelta * 1.5, longitudeDelta: locationManager.region.span.longitudeDelta * 1.5)
                                    locationManager.region.span = newSpan
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Circle().foregroundColor(.black).opacity(0.5))
                                }
                                
                                Spacer()
                                
                                // Button to zoom in
                                Button(action: {
                                    let newSpan = MKCoordinateSpan(latitudeDelta: locationManager.region.span.latitudeDelta / 1.5, longitudeDelta: locationManager.region.span.longitudeDelta / 1.5)
                                    locationManager.region.span = newSpan
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Circle().foregroundColor(.black).opacity(0.5))
                                }
                            }
                            .padding()
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
                
                // Restaurant detail sheet
                .sheet(item: $selectedRestaurant) { restaurant in
                    RestaurantDetailSheet(restaurant: restaurant)
                }
                
                .navigationTitle("Home")
                .navigationBarItems(trailing: Button(action: {
                    isShowingNotification = true
                }) {
                    Image(systemName: "bell.badge.fill")
                })
            }
        }
        .accentColor(Color.primaryGreen)
        .onAppear {
            fetchUserNameFromDatabase()
        }
    }
    private func fetchUserNameFromDatabase() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No hay usuario autenticado")
            userName = "there"
            return
        }
        
        print("Buscando usuario con ID: \(userID)")
        
        let dbRef = Database.database().reference()
        dbRef.child("users").child(userID).observeSingleEvent(of: .value) { snapshot in
            print("Snapshot recibido: \(snapshot)")
            
            if let userData = snapshot.value as? [String: Any] {
                print("Datos del usuario: \(userData)")
                self.userName = userData["firstName"] as? String ?? "there"
            } else {
                print("No se encontraron datos para el usuario")
                self.userName = "there"
            }
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
        Restaurant(image: Image("restaurant1"), name: "Santoua", distance: "1.2 km", calories: "450 kcal"),
        Restaurant(image: Image("restaurant2"), name: "Cus Cus Cus", distance: "850 m", calories: "520 kcal")
    ]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Populares cerca de ti")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.horizontal)

            HStack(spacing: 16) {
                ForEach(restaurants) { restaurant in
                    VStack(alignment: .leading) {
                        restaurant.image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 160, height: 160)
                            .cornerRadius(12)
                            .clipped()

                        VStack(alignment: .leading) {
                            Text(restaurant.name)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            Text(restaurant.distance)
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(restaurant.calories)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 5)
                    }
                    .frame(width: 160)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
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
                    gradient: Gradient(colors: [Color.primaryGreen.opacity(0.8), Color.navyBlue.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: 351, height: 165)
                .cornerRadius(12)

                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("This week's activity")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(.black.opacity(0.2))
                                .cornerRadius(20)
                            Spacer()
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("🚶‍♀️ 8,420 pasos")
                            Text("📏 5.7 km")
                            Text("🔥 388 kcal")
                        }
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.black.opacity(0.2))
                        .cornerRadius(12)
                    }

                    Spacer()

                    ZStack {
                        Circle()
                            .stroke(lineWidth: 8)
                            .opacity(0.2)
                            .foregroundColor(.white)

                        Circle()
                            .trim(from: 0.0, to: 0.65)
                            .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                            .foregroundColor(.mustardYellow)
                            .rotationEffect(Angle(degrees: -90))
                            .animation(.easeOut(duration: 1.0), value: 0.65)

                        Text("65%")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .frame(width: 60, height: 60)
                    .padding(.trailing)
                }
                .padding()
            }
        }
        .background(
            NavigationLink(destination: WeeklyActivityDetailView(), isActive: $navigateToDetail) {
                EmptyView()
            }
        )
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 16, x: 0, y: 0)
        .frame(width: 351, height: 165)
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
        HomeView()
            .navigationBarBackButtonHidden(true)
    }
}
