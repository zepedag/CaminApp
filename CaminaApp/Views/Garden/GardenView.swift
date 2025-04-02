import SwiftUI

struct GardenView: View {
    var garden: Garden
    
    var body: some View {
        ScrollView {
            Text(garden.description)
                .font(.system(size: 17))
                .padding(.top, 20)

            
            let gridItems = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
            
            LazyVGrid(columns: gridItems, spacing: 20) {
                AddPlantButtonView()
                
                ForEach(garden.plants, id: \.myPlant.alias) { myPlant in
                    PlantMiniCardView(plant: myPlant)
                }
            }
            .navigationTitle("Plants of \(garden.name)")
            .accentColor(.primaryGreen)
            .padding()
        }
    }
}
    
struct AddPlantButtonView: View {
    @State private var navigateToNewPlantView = false
        
    var body: some View {
        Button(action: {
            navigateToNewPlantView = true
        }) {
            VStack {
                Image(systemName: "plus.app")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.primaryGreen)
                    .padding(.top)
                
                Text("Add")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primaryGreen)
                
                Text("New plant")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.bottom)
            }
            .frame(width: 100, height: 100)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.4), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .background(NavigationLink(destination: NewPlantView(), isActive: $navigateToNewPlantView) { EmptyView() })
    }
}

struct GardenView_Previews: PreviewProvider {
    static var previews: some View {
        // Generar usuarios y seleccionar un jardín de ejemplo
        let exampleGarden = generateExampleUsers().first?.gardens.first!
        
        // Pasar el jardín de ejemplo a GardenView
        GardenView(garden: exampleGarden!)
    }
}
