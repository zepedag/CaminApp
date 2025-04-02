import SwiftUI

struct HomeView: View {
    @State private var isShowingNotification = false
    var name: String = "Megan"
    
    var body: some View {
        NavigationView {
            ScrollView{
                NavigationLink(destination: NotificationView(), isActive: $isShowingNotification) { EmptyView() }
                HStack {
                    VStack(alignment: .leading){
                        Text("Hi \(name),")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            
                        Text("Welcome back!")
                            .font(.title2)
                            .foregroundColor(.primaryGreen)
                    }
                    Spacer()
                }
                .padding()
                
                PlantOfTheDayView(plant: Tomato)
                
                RecentActivityView()
                
                TipOfTheDayView()
                
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

struct PlantOfTheDayView: View {
    @State private var navigateToPlantView = false
    var plant: Plant // Parámetro para los datos de la planta
    @State private var selectedPlant: Plant? // Para la navegación

    var body: some View {
        Button(action: {
            self.selectedPlant = plant
            navigateToPlantView = true
        }) {
            ZStack {
                plant.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 351, height: 165)
                    .clipped()
                    .cornerRadius(12)
                
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(red: 0.38, green: 0.42, blue: 0.22).opacity(0.5), location: 0.00),
                        .init(color: Color(red: 0.4, green: 0.4, blue: 0.4).opacity(0.5), location: 1.00),
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: 351, height: 165)
                .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack{
                        HStack{
                            Text("Plant of the day")
                                .fontWeight(.semibold)
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.black.opacity(0.15))
                        .cornerRadius(40)
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "book.pages.fill")
                                .foregroundColor(.white)
                            Text(plant.alias)
                                .font(Font.custom("SF Pro Display", size: 15).weight(.bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.black.opacity(0.15))
                        .cornerRadius(40)
                    }
                    
                    Spacer()
                    
                    HStack {
                        HStack{
                            Image(systemName: "location.fill")
                                .foregroundColor(.white)
                            Text("Backyard")
                                .font(Font.custom("SF Pro Display", size: 15).weight(.bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.black.opacity(0.15))
                        .cornerRadius(40)
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.black.opacity(0.15))
                        .cornerRadius(40)
                    }
                }
                .padding()
                .frame(width: 351, height: 165)
                .cornerRadius(12)
            }
        }
        .background(NavigationLink(destination: GeneralPlantView(plant : myTomato), isActive: $navigateToPlantView) {
            EmptyView()
        })
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 16, x: 0, y: 0)
        .frame(width: 351, height: 165, alignment: .leading)
    }
}

struct ActivityItem: Identifiable {
    let id = UUID()
    let plantName: String
    let activityDescription: String
    let timeAgo: String
}

struct RecentActivityView: View {
    @State var activities: [ActivityItem] = [
        ActivityItem(plantName: "Sophia", activityDescription: "You watered Sophia!", timeAgo: "1 day ago"),
        ActivityItem(plantName: "Sprouty", activityDescription: "You captured Sprouty en Wednesday.", timeAgo: "3 days ago")
    ]
    
    var color = Color.primaryGreen.opacity(0.15)
    
    var body: some View {
        VStack {
            HStack {
                Text("Recent Activity")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            ForEach(activities) { activity in
                HStack {
                    VStack(alignment: .leading) {
                        Text(activity.plantName).italic()
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryGreen)
                        Text(activity.activityDescription)
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text(activity.timeAgo)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color(red: 0.38, green: 0.42, blue: 0.22).opacity(0.15))
                .cornerRadius(12)
                .padding(.vertical, 2)
            }
            Spacer()
            
            Button("See more") {
                // Agrega la lógica para manejar el botón de See more
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            .background(color)
            .cornerRadius(15)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 0)
        .frame(width: 351, height: 240, alignment: .leading)
        .padding()
    }
}

struct TipOfTheDayView: View {
    var body: some View {
        ZStack {
                Image("tip")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .cornerRadius(12)
                
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(red: 0.38, green: 0.42, blue: 0.22).opacity(0.5), location: 0.00),
                        .init(color: Color(red: 0.4, green: 0.4, blue: 0.4).opacity(0.5), location: 1.00),
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: 351, height: 351)
                .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack{
                        HStack{
                            Text("Tip of the day")
                                .fontWeight(.semibold)
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.black.opacity(0.15))
                        .cornerRadius(40)
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "drop.fill")
                                .foregroundColor(.white)
                            Text("Watering")
                                .font(Font.custom("SF Pro Display", size: 15).weight(.bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.black.opacity(0.15))
                        .cornerRadius(40)
                    }
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 100)
                    
                    HStack {
                        VStack(alignment: .center){
                            Text("Rainfall")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .font(.title3)
                            Text("Watering plants with a 'rainfall' technique mimics natural weather, providing a gentle, even soak that reaches deep roots and promotes healthy growth. This is essential for the long-term vitality of your plants, as deep watering supports resilience against drought and disease.")
                                .font(Font.custom("SF Pro Display", size: 15).weight(.bold))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(0)
                        .padding(.top, 10)
                        .padding(.horizontal, 16)
                        .frame(width: 319, height: 170)
                        .background(.black.opacity(0.35))
                        .cornerRadius(12)
                    }
                    
                    Spacer()
                }
                .padding()
                .frame(width: 351, height: 351)
                .cornerRadius(12)
            }
        
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 16, x: 0, y: 0)
        .frame(width: 351, height: 351, alignment: .leading)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
