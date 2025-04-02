import SwiftUI

struct GardenCardView: View {
    @State private var navigateToGardenView = false
    var garden: Garden // Parámetro para los datos del jardín
    @State private var selectedGarden: Garden? // Para la navegación

    var body: some View {
        // Contenido de la tarjeta
        Button(action: {
            self.selectedGarden = garden
            navigateToGardenView = true
        }) {
            ZStack {
                // Imagen de fondo del jardín
                garden.gardenpic
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 351, height: 165)
                    .cornerRadius(12)
                    .clipped()
                
                // Gradiente sobre la imagen de fondo
                LinearGradient(
                    stops: [
                        .init(color: Color(red: 0.38, green: 0.42, blue: 0.22).opacity(0.5), location: 0.00),
                        .init(color: Color(red: 0.4, green: 0.4, blue: 0.4).opacity(0.5), location: 1.00),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: 351, height: 165)
                .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack{
                        HStack{
                            Text(garden.name)
                                .fontWeight(.bold)
                                .font(.custom("SF Pro Display", size: 17))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.white.opacity(0.15))
                        .cornerRadius(40)
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "leaf.fill")
                                .foregroundColor(.white)
                            Text("\(garden.numberOfPlants) total plants") // Número total de plantas
                                .font(Font.custom("SF Pro Display", size: 15).weight(.bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.white.opacity(0.15))
                        .cornerRadius(40)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.white)
                        Text(garden.location)
                            .font(Font.custom("SF Pro Display", size: 15).weight(.bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.white.opacity(0.15))
                    .cornerRadius(40)
                }
                .padding()
                .frame(width: 351, height: 165)
                .cornerRadius(12)
            }
            .frame(width: 351, height: 165, alignment: .leading)
        }
        .background(NavigationLink(destination: GeneralGardenView(garden: selectedGarden ?? garden), isActive: $navigateToGardenView) {
            EmptyView()
        })
    }
}

struct GardenCardView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleGarden = (generateExampleUsers().first?.gardens.first!)!
                GardenCardView(garden: exampleGarden)
    }
}

