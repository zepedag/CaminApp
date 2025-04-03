import SwiftUI
import MapKit
import CoreLocation

struct HealthyCravingSearchView: View {
    @State private var searchText: String
    @State private var searchResults: [Restaurant] = []
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var routeType = "Normal"
    @State private var startPoint = ""
    @State private var endPoint = ""
    
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
        VStack(spacing: 0) {
            if !searchResults.isEmpty {
                FitnessFactsCarousel(facts: FitnessFactsCarousel.defaultFacts)
                    .padding(.top, 10)
            }

            SearchBar(text: $searchText, placeholder: "Busca tu antojito...", onCommit: performSearch)
                .padding(.horizontal)
                .padding(.bottom, 10)
                .padding(.top)
                .onChange(of: searchText) { newValue in
                    if newValue.isEmpty {
                        searchResults = []
                    }
                }
            
            Picker("Route Type", selection: $routeType) {
                Text("Normal").tag("Normal")
                Text("Custom").tag("Custom")
            }

            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            if routeType == "Custom" {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Set Your Route")
                        .font(.headline)
                        .padding(.bottom, 5)
                        .padding(.top, 10)

                    HStack {
                        Image(systemName: "location.circle.fill")
                            .foregroundColor(.blue)
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(height: 40) // Altura personalizada
                                .shadow(radius: 2)
                            
                            TextField("Starting point", text: $startPoint)
                                .padding(.horizontal, 10)
                        }
                    }

                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.red)
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(height: 40) // Altura personalizada
                                .shadow(radius: 2)
                            
                            TextField("Destination", text: $endPoint)
                                .padding(.horizontal, 10)
                        }
                    }




                    Button(action: updateMockRouteData) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                            Text("Save Route")
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.primaryGreen)
                    .padding(.top, 5)
                }
                .padding(.horizontal)
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
    
    private var resultsList: some View {
        List(searchResults) { restaurant in
            HStack {
                Spacer()
                RestaurantCardView(restaurant: restaurant)
                    .frame(maxWidth: 350)
                Spacer()
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
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
    
    private func updateMockRouteData() {
        searchResults = searchResults.map { restaurant in
            var updatedRestaurant = restaurant
            updatedRestaurant.distance += 0.5
            updatedRestaurant.walkingTime += 5
            return updatedRestaurant
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
}

struct HealthyCravingSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HealthyCravingSearchView()
        }
    }
}

