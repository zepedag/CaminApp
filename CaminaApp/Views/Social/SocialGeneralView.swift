import SwiftUI
import MapKit

struct SocialGeneralView: View {
    let visitedPlaces = [
        Restaurants(name: "Ramen House", description: "Popular Asian ramen spot.", image: Image("restaurant1"), location: CLLocationCoordinate2D(latitude: 19.0640, longitude: -98.3036), menu: [], visitedBy: [], reviews: []),
        Restaurants(name: "Tacos El Güero", description: "Street-style tacos.", image: Image("restaurant2"), location: CLLocationCoordinate2D(latitude: 19.0632, longitude: -98.3051), menu: [], visitedBy: [], reviews: []),
        Restaurants(name: "Pizza Urbana", description: "Wood-fired pizzas and craft beers.", image: Image("restaurant3"), location: CLLocationCoordinate2D(latitude: 19.0620, longitude: -98.3024), menu: [], visitedBy: [], reviews: []),
        Restaurants(name: "Green Garden", description: "Vegetarian and vegan dishes.", image: Image("restaurant4"), location: CLLocationCoordinate2D(latitude: 19.0610, longitude: -98.3045), menu: [], visitedBy: [], reviews: []),
        Restaurants(name: "Sushi Kai", description: "Modern sushi fusion.", image: Image("restaurant5"), location: CLLocationCoordinate2D(latitude: 19.0605, longitude: -98.3060), menu: [], visitedBy: [], reviews: [])
    ]

    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    
                    // Círculos de progreso
                    DashboardSection()
                    
                    // Actividad social rediseñada con tarjetas visuales
                    SocialCardView(title: "Friends' Activity", icon: "person.2.fill") {
                        VStack(spacing: 12) {
                            ActivityCard(username: "Sofía", action: "reviewed", target: "Ramen House", icon: "pencil", color: .blue)
                            ActivityCard(username: "Luis", action: "favorited", target: "Tacos El Güero", icon: "bookmark.fill", color: .orange)
                            ActivityCard(username: "Diego", action: "visited", target: "Pizza Urbana", icon: "location.fill", color: .green)
                        }
                    }

                    // Gráfico de barras
                    SocialCardView(title: "Reviews by Category", icon: "chart.bar") {
                        BarChartView(data: [("Asian", 8), ("Mexican", 5), ("Italian", 3)])
                    }

                    // Mapa de visitas
                    SocialCardView(title: "Map of Visited Places", icon: "map.fill") {
                        MapMultiplePointsView(
                            restaurants: visitedPlaces,
                            userLocation: CLLocationCoordinate2D(latitude: 19.0625, longitude: -98.3040)
                        )
                        .frame(height: 200)
                        .cornerRadius(12)
                    }


                    SocialCardView(title: "Achievements", icon: "rosette") {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                AchievementBadge(
                                    title: "Foodie Rookie",
                                    icon: "leaf.fill",
                                    badgeColor: Color(red: 0.2, green: 0.6, blue: 0.3),
                                    iconColor: Color(red: 0.13, green: 0.5, blue: 0.22)
                                )

                                AchievementBadge(
                                    title: "Explorer LVL 2",
                                    icon: "map.fill",
                                    badgeColor: Color.blue.opacity(0.85),
                                    iconColor: Color.indigo
                                )

                                AchievementBadge(
                                    title: "Top Reviewer",
                                    icon: "star.fill",
                                    badgeColor: Color.primaryGreen.opacity(0.3),
                                    iconColor: Color(red: 0.85, green: 0.4, blue: 0.1)
                                )
                            }
                            .padding(.vertical, 4)
                        }
                    }

                }
                .padding(14)
            }
            .navigationTitle("Social")
        }
        .accentColor(.primaryGreen)
    }
}

struct ActivityCard: View {
    var username: String
    var action: String
    var target: String
    var icon: String
    var color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .padding(10)
                .background(Circle().fill(color))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(username) \(action)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text(target)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: color.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}


struct AchievementBadge: View {
    var title: String
    var icon: String
    var badgeColor: Color
    var iconColor: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.white)
                .padding(6)
                .background(Circle().fill(iconColor))

            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(badgeColor)
        .cornerRadius(20)
        .shadow(color: badgeColor.opacity(0.4), radius: 6, x: 0, y: 2)
    }
}



#Preview {
    SocialGeneralView()
}

struct DashboardSection: View {
    var body: some View {
        HStack(spacing: 20) {
            CircularStatView(icon: "fork.knife", progress: 0.21, label: "Visits")
            CircularStatView(icon: "star.fill", progress: 0.45, label: "Reviews")
            CircularStatView(icon: "bookmark.fill", progress: 0.75, label: "Favorites")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

struct CircularStatView: View {
    var icon: String
    var progress: CGFloat
    var label: String

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 6)
                    .frame(width: 60, height: 60)

                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(Color.primaryGreen, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 60, height: 60)

                Image(systemName: icon)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Circle().fill(Color.primaryGreen))
            }

            Text("\(Int(progress * 100))%")
                .font(.headline)
                .foregroundColor(.primaryGreen)

            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(width: 80)
    }
}

struct BarChartView: View {
    var data: [(String, Int)]

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(data, id: \.0) { category, value in
                HStack {
                    Text(category)
                        .frame(width: 80, alignment: .leading)
                        .font(.caption)
                    Rectangle()
                        .fill(Color.primaryGreen)
                        .frame(width: CGFloat(value) * 20, height: 14)
                        .cornerRadius(6)
                    Text("\(value)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.top, 8)
    }
}

struct SocialCardView<Content: View>: View {
    var title: String
    var icon: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label(title, systemImage: icon)
                    .font(.title2.bold())
                    .foregroundColor(.black)
                Spacer()
            }
            content
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 2)
        .padding(.horizontal, 4)
    }
}
