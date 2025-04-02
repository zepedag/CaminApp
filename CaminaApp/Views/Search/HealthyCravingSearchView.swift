import SwiftUI
import MapKit
import CoreLocation

struct HealthyCravingSearchView: View {
    @State private var searchText: String
    @State private var searchResults: [Restaurant] = []
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    init(initialSearchText: String = "") {
        self._searchText = State(initialValue: initialSearchText)
        self._searchResults = State(initialValue: [])
    }
    
    let allRestaurants: [Restaurant] = [
        Restaurant(
            id: UUID(),
            name: "Antojitos Mary",
            foodType: "Tacos",
            distance: 0.5,
            walkingTime: 8,
            caloriesInFood: 450,
            coordinate: CLLocationCoordinate2D(latitude: 19.042, longitude: -98.207)
        ),
        Restaurant(
            id: UUID(),
            name: "Healthy Burgers",
            foodType: "Hamburguesas",
            distance: 1.2,
            walkingTime: 15,
            caloriesInFood: 550,
            coordinate: CLLocationCoordinate2D(latitude: 19.043, longitude: -98.205)
        ),
        Restaurant(
            id: UUID(),
            name: "Sushi Light",
            foodType: "Sushi",
            distance: 0.8,
            walkingTime: 10,
            caloriesInFood: 400,
            coordinate: CLLocationCoordinate2D(latitude: 19.044, longitude: -98.204)
        )
    ]
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText, placeholder: "Busca tu antojito...", onCommit: performSearch)
                .padding(.horizontal)
                .padding(.top)
                .onChange(of: searchText) { newValue in
                    if newValue.isEmpty {
                        searchResults = []
                    }
                }
            
            if isLoading {
                ProgressView()
                    .padding()
            } else if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if searchResults.isEmpty && !searchText.isEmpty {
                Text("No se encontraron resultados para \"\(searchText)\"")
                    .foregroundColor(.gray)
                    .padding()
            } else if searchResults.isEmpty {
                emptyStateView
            } else {
                resultsList
            }
            
            Spacer()
        }
        .navigationTitle("Buscar antojitos")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if !searchText.isEmpty {
                performSearch()
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.primaryGreen)
                .padding()
            Text("Encuentra tu antojito saludable")
                .font(.title2)
                .fontWeight(.semibold)
            Text("Busca tu comida favorita y descubre opciones locales con información sobre calorías quemadas al caminar")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding()
        }
        .padding(.top, 50)
    }
    
    private var resultsList: some View {
        List(searchResults) { restaurant in
            RestaurantCardView(restaurant: restaurant)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
    }
    
    private func performSearch() {
        guard !searchText.isEmpty else {
            searchResults = []
            return
        }
        
        isLoading = true
        showError = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let lowercasedQuery = searchText.lowercased()
            let results = allRestaurants.filter {
                $0.name.lowercased().contains(lowercasedQuery) ||
                $0.foodType.lowercased().contains(lowercasedQuery)
            }
            
            isLoading = false
            searchResults = results
            
            if results.isEmpty {
                errorMessage = "No se encontraron restaurantes para \"\(searchText)\""
                showError = true
            }
        }
    }
}

// Modelos y componentes auxiliares (Restaurant, RestaurantCardView, etc.) permanecen igual
// MARK: - Restaurant Model
struct Restaurant: Identifiable {
    let id: UUID
    let name: String
    let foodType: String
    let distance: Double // in km
    let walkingTime: Int // in minutes
    let caloriesInFood: Int
    let coordinate: CLLocationCoordinate2D
    
    // Calories burned walking (approx 60 kcal per km)
    var caloriesBurned: Int {
        Int(Double(distance) * 60)
    }
    
    var caloriesPercentage: Double {
        min(Double(caloriesBurned) / Double(caloriesInFood), 1.0)
    }
}

// MARK: - Restaurant Card View
struct RestaurantCardView: View {
    let restaurant: Restaurant
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
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
                
                Spacer()
                
                // Calorie comparison circle
                CalorieComparisonView(percentage: restaurant.caloriesPercentage)
                    .frame(width: 60, height: 60)
            }
            
            // Nutrition info
            HStack {
                NutritionBadge(value: "\(restaurant.caloriesInFood) kcal", label: "Comida", color: .orange)
                NutritionBadge(value: "\(restaurant.caloriesBurned) kcal", label: "Quemadas", color: .primaryGreen)
                NutritionBadge(value: "\(Int((1 - restaurant.caloriesPercentage) * 100))%", label: "Neto", color: .purple)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Calorie Comparison View
struct CalorieComparisonView: View {
    let percentage: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 8)
                .opacity(0.2)
                .foregroundColor(.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(percentage, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                .foregroundColor(percentage >= 1.0 ? .green : .primaryGreen)
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeOut, value: percentage)
            
            VStack {
                Text("\(Int(percentage * 100))%")
                    .font(.system(size: 12, weight: .bold))
                Text("quemado")
                    .font(.system(size: 8))
            }
        }
    }
}

// MARK: - Nutrition Badge
struct NutritionBadge: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack {
            Text(value)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.gray)
        }
        .padding(6)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - Search Bar (Reusable Component)
struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    var onCommit: () -> Void
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text, onCommit: onCommit)
                .padding(8)
                .padding(.horizontal, 24)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !text.isEmpty {
                            Button(action: {
                                text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
        }
    }
}

// MARK: - Preview
struct HealthyCravingSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HealthyCravingSearchView()
        }
    }
}
