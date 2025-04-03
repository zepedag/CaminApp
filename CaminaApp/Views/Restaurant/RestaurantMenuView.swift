import SwiftUI

struct RestaurantMenuView: View {
    let menu: [Dish]
    @State private var favorites: Set<UUID> = []

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Menu")
                .font(.title2.bold())
                .foregroundColor(.primaryGreen)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(menu) { dish in
                        ZStack {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(dish.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)

                                    Spacer()

                                    Button(action: {
                                        toggleFavorite(dishID: dish.id)
                                    }) {
                                        Image(systemName: favorites.contains(dish.id) ? "heart.fill" : "heart")
                                            .foregroundColor(.primaryGreen)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .padding(.top, -15)
                                }

                                Text("\(dish.calories) kcal")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    Text("$\(String(format: "%.2f", dish.price))")
                                        .font(.caption2)
                                        .foregroundColor(.primaryGreen)
                                    Spacer()
                                    Image(systemName: "plus.circle")
                                            .foregroundColor(.primaryGreen)
                                }
                                
                            }
                            .padding()
                            .frame(width: 140, height: 110)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                        }
                        .padding(.vertical, 6)
                    }
                }

            }
        }
        .padding(.horizontal)
    }

    private func toggleFavorite(dishID: UUID) {
        if favorites.contains(dishID) {
            favorites.remove(dishID)
        } else {
            favorites.insert(dishID)
        }
    }
}

#Preview {
    let sampleMenu: [Dish] = [
        Dish(name: "Tacos al Pastor", calories: 450, price: 14.99),
        Dish(name: "Chiles en Nogada", calories: 700, price: 169.99),
        Dish(name: "Mole Poblano", calories: 600, price: 129.99),
        Dish(name: "Pizza Margarita", calories: 860, price: 199.90),
        Dish(name: "Ramen Tonkotsu", calories: 820, price: 175.25),
    ]

    return RestaurantMenuView(menu: sampleMenu)
}
