import SwiftUI
import Charts
import MapKit
import Firebase
import FirebaseAuth

struct ProfileView: View {
    @State private var isShowingSettings = false
    @State private var userName: String = "Loading..."
    @State private var userEmail: String = ""
    @State private var userAge: Int = 0
    @State private var isShowingVisitRest = false
    
    let visitedPlaces = [
        Restaurants(name: "McDonald's", description: "Fast food chain with burgers and fries.", image: Image("restaurant1"), location: CLLocationCoordinate2D(latitude: 19.0610, longitude: -98.3062), menu: [], visitedBy: [], reviews: []),
        Restaurants(name: "Little Caesars", description: "Pizza restaurant known for Hot-N-Ready.", image: Image("restaurant2"), location: CLLocationCoordinate2D(latitude: 19.0620, longitude: -98.3050), menu: [], visitedBy: [], reviews: []),
        Restaurants(name: "KFC", description: "Famous for fried chicken and sides.", image: Image("restaurant3"), location: CLLocationCoordinate2D(latitude: 19.0630, longitude: -98.3040), menu: [], visitedBy: [], reviews: [])
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    NavigationLink(destination: SettingsView(), isActive: $isShowingSettings) { EmptyView() }
                    
                    // Profile Header
                    VStack(spacing: 8) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.primaryGreen)
                        
                        Text("\(userName)")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(userEmail)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                    
                    // Personal details
                    GroupBox(label: Label("About Me", systemImage: "person.text.rectangle")
                                .foregroundColor(.primaryGreen)) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.primaryGreen)
                                    .frame(width: 20)
                                Text(userEmail)
                                    .font(.callout)
                            }
                            
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.primaryGreen)
                                    .frame(width: 20)
                                Text("\(userAge) years")
                                    .font(.callout)
                            }
                            
                            HStack {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.primaryGreen)
                                    .frame(width: 20)
                                Text("Puebla, MX")
                                    .font(.callout)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .padding(.horizontal)
                    
                    // Achievements Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Achievements")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.leading, 16)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                AchievementView(icon: "figure.walk", text: "10,000\nSteps", color: .white)
                                AchievementView2(icon: "leaf.fill", text: "Vegan for\na Week", color: .white)
                                AchievementView3(icon: "fork.knife", text: "Tried 50\nDishes", color: .white)
                                AchievementView4(icon: "cup.and.saucer.fill", text: "Coffee\nEnthusiast", color: .white)
                                AchievementView5(icon: "figure.wave", text: "Morning\nWalker", color: .white)
                                AchievementView6(icon: "shoeprints.fill", text: "Trail\nExpert", color: .white)
                                AchievementView7(icon: "signpost.right.fill", text: "Route\nExplorer", color: .white)
                                AchievementView8(icon: "map.circle.fill", text: "Full Route\nCompletion", color: .white)


                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    HStack {
                        SocialCardView(title: "Visited Restaurants", icon: "fork.knife") {
                            VStack(spacing: 12) {
                                HStack {
                                    ActivityCard(
                                        username: "\(userName)",
                                        action: "Visited",
                                        target: "McDonald's",
                                        icon: "m.circle.fill",
                                        color: .yellow,
                                        restaurant: visitedPlaces[0],
                                        userLocation: visitedPlaces[0].location
                                    )
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.darkGreen)
                                }
                                HStack {
                                    ActivityCard(
                                        username: "\(userName)",
                                        action: "Visited",
                                        target: "Little Caesars",
                                        icon: "flame.fill",
                                        color: .darkorange,
                                        restaurant: visitedPlaces[1],
                                        userLocation: visitedPlaces[1].location
                                    )
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.darkGreen)
                                }
                                HStack {
                                    ActivityCard(
                                        username: "\(userName)",
                                        action: "Visited",
                                        target: "KFC",
                                        icon: "leaf.fill",
                                        color: .red,
                                        restaurant: visitedPlaces[2],
                                        userLocation: visitedPlaces[2].location
                                    )
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.darkGreen)
                                }
                                HStack {
                                    NavigationLink(destination: VisitedRestaurantsView()) {
                                                                           Text("View All")
                                                                               .foregroundColor(.darkGreen)
                                                                               .font(.title3)
                                                                       }
                                }
                            }
                        }
                       
                        .foregroundColor(.blue)
                        .font(.subheadline)
                    }
                    .padding(.top, 20)

                }
                
                
            }
            .navigationBarItems(trailing: Button(action: {
                isShowingSettings = true
            }) {
                Image(systemName: "gear")
                    .font(.system(size: 20))
            })
            .navigationBarTitle("My Profile", displayMode: .inline)
            .navigationDestination(isPresented: $isShowingVisitRest) {
                VisitedRestaurantsView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .accentColor(Color.primaryGreen)
        .onAppear {
            fetchUserDataFromDatabase()
        }
    }
    
    private func fetchUserDataFromDatabase() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No authenticated user")
            userName = "Guest"
            return
        }
        
        let dbRef = Database.database().reference()
        dbRef.child("users").child(userID).observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any] {
                DispatchQueue.main.async {
                    self.userName = userData["firstName"] as? String ?? "User"
                    self.userEmail = userData["email"] as? String ?? "No email"
                    self.userAge = userData["age"] as? Int ?? 0
                }
            } else {
                DispatchQueue.main.async {
                    self.userName = "User"
                    self.userEmail = Auth.auth().currentUser?.email ?? "No email"
                }
            }
        }
    }
}

// Achievement Views (keep your existing implementations)
struct AchievementView: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(Color.mustardYellow)
                    .frame(width: 60, height: 60)
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(color)
            }
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
    }
}

struct AchievementView2: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(Color.deepBlue)
                    .frame(width: 60, height: 60)
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(color)
            }
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
    }
}

struct AchievementView3: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(Color.opaqueRed)
                    .frame(width: 60, height: 60)
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(color)
            }
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
    }
}

struct AchievementView4: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(Color.lightGreen)
                    .frame(width: 60, height: 60)
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(color)
            }
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
    }
}
struct AchievementView5: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(Color.purple)
                    .frame(width: 60, height: 60)
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(color)
            }
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
    }
}

struct AchievementView6: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(Color.cyan)
                    .frame(width: 60, height: 60)
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(color)
            }
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
    }
}

struct AchievementView7: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 60, height: 60)
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(color)
            }
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
    }
}

struct AchievementView8: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(Color.indigo)
                    .frame(width: 60, height: 60)
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(color)
            }
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
    }
}


// Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

