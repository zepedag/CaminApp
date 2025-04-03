import SwiftUI

struct VisitedRestaurantsView: View {
    var body: some View {
        VStack {
            Text("Visited Restaurants")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            ScrollView {
                VStack(spacing: 12) {
                    restaurantRow(name: "McDonald's", icon: "m.circle.fill", color: .yellow, date: "04/12")
                    restaurantRow(name: "Little Caesars", icon: "flame.fill", color: .orange, date: "13/12")
                    restaurantRow(name: "KFC", icon: "leaf.fill", color: .red, date: "27/11")
                    restaurantRow(name: "Cinépolis Snack Bar", icon: "popcorn.fill", color: .blue, date: "25/11")
                    restaurantRow(name: "House Roll", icon: "fork.knife", color: .purple, date: "28/03")
                }
            }
            .padding()
        }
        .accentColor(Color.primaryGreen)
    }
    
    func restaurantRow(name: String, icon: String, color: Color, date: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 35))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("\(date)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.darkGreen)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
       
}

struct VisitedRestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        VisitedRestaurantsView()
    }
}

