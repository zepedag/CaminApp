import SwiftUI
import MapKit

struct SocialGeneralView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    
                    // Círculos de progreso
                    DashboardSection()

                    // Gráfico de barras
                    SocialCardView(title: "Reviews by Category", icon: "chart.bar") {
                        BarChartView(data: [("Asian", 8), ("Mexican", 5), ("Italian", 3)])
                    }

                    // Mapa de visitas
                    SocialCardView(title: "Map of Visited Places", icon: "map.fill") {
                        MiniMapView()
                            .frame(height: 200)
                            .cornerRadius(12)
                    }

                    // Logros
                    SocialCardView(title: "Achievements", icon: "rosette") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("🏅 Foodie Rookie")
                            Text("🏅 Explorer LVL 2")
                            Text("🏅 Top Reviewer")
                        }
                        .font(.body)
                        .foregroundColor(.primaryGreen)
                    }

                    // Actividad social
                    SocialCardView(title: "Friends' Activity", icon: "person.2.fill") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("🍽️ Sofía reviewed Ramen House")
                            Text("🌮 Luis favorited Tacos El Güero")
                            Text("🍕 Diego visited Pizza Urbana")
                        }
                        .font(.callout)
                        .foregroundColor(.gray)
                    }
                }
                .padding(14)
            }
            .navigationTitle("Social")
        }
        .accentColor(.primaryGreen)
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

struct MiniMapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332), // CDMX por defecto
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )

    var body: some View {
        Map(coordinateRegion: $region)
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
