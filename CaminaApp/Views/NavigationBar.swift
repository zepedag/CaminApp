import SwiftUI
import MapKit

struct NavigationBar: View {
    @State private var selectedTab = 1
    
    let users = generateExampleUsers()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SocialGeneralView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Social")
                }
                .tag(0)
            
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
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(2)
        }
        .navigationBarBackButtonHidden(true)
        .accentColor(Color.primaryGreen)
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar()
            .navigationBarBackButtonHidden(true)
    }
}



