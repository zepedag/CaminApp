import SwiftUI
import MapKit

struct HomeView: View {
    @State private var isShowingNotification = false
    @State private var searchText = ""
    @State private var selectedCategory = "Todas"
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.0413, longitude: -98.2062),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var isShowingSearchResults = false
    var name: String = "Megan"

    var body: some View {
        NavigationView {
            ScrollView {
                // Notification Navigation
                NavigationLink(destination: NotificationView(), isActive: $isShowingNotification) { EmptyView() }
                
                // Hidden navigation link for search results
                NavigationLink(
                    destination: HealthyCravingSearchView(initialSearchText: searchText),
                    isActive: $isShowingSearchResults
                ) { EmptyView() }
                
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text("  Hi \(name),")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }

                // Search Section
                VStack(alignment: .leading, spacing: 10) {
                    // Search field with return key handler
                    TextField("Vamos a comer...", text: $searchText, onCommit: {
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

                    // Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(["Todas", "Hamburguesas", "Tacos", "Sushi", "Cafés"], id: \.self) { category in
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
                }
                .padding(.horizontal)
                .padding()

                // Resto de tu contenido permanece igual...
                WeeklyActivitySummaryView()
                PopularNearbyView()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Explore nearby places")
                        .font(.headline)
                        .foregroundColor(.primaryGreen)
                        .padding(.top, 16)
                        .padding(.horizontal)

                    Map(coordinateRegion: $region)
                        .frame(height: 200)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.bottom)

                .navigationTitle("Home")
                .navigationBarItems(trailing: Button(action: {
                    isShowingNotification = true
                }) {
                    Image(systemName: "bell.badge.fill")
                })
            }
        }
        .accentColor(Color.primaryGreen)
    }
}

// Resto de tus estructuras (PopularNearbyView, WeeklyActivitySummaryView, etc.) permanecen igual
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

struct WeeklyActivitySummaryView: View {
    @State private var navigateToDetail = false

    var body: some View {
        Button(action: {
            navigateToDetail = true
        }) {
            ZStack {
                // Fondo difuminado bonito usando colores definidos
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

                    // Mini círculo de progreso
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
                .frame(width: 351, height: 165)
            }
        }
        .background(
            NavigationLink(destination: GeneralPlantView(plant: myTomato), isActive: $navigateToDetail) {
                EmptyView()
            }
        )
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 16, x: 0, y: 0)
        .frame(width: 351, height: 165, alignment: .leading)
    }
}

struct WeeklyActivityDetailView: View {
    var body: some View {
        Text("Detalle de la actividad semanal")
            .font(.title)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
