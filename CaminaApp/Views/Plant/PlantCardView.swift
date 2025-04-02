import SwiftUI

struct PlantCardView: View {
    let plant: Plant
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {  // Adjusted spacing between VStack elements
            // Image with corner radius and shadow
            plant.image
                .resizable()
                .scaledToFill()
                .frame(width: 319, height: 240.5)
                .clipped()
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 16, x: 0, y: 0)

            // Tomato title and More info button in an HStack
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(plant.commonName)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryGreen)

                    Text(plant.scientificName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()  // Pushes the button to the right

                Button("More info...") {
                    // Action for more info button
                }
                .padding(5)
                .background(Color.primaryGreen.opacity(0.15))
                .cornerRadius(40)
                .foregroundColor(.primaryGreen)
            }
            .padding(.trailing)  // Add padding to the right side of the button

            // ScrollView containing the rest of the information
            ScrollView {
                HStack{
                    Text("Difficulty")
                        .font(.headline)
                        .foregroundColor(.primaryGreen)
                        .padding(.top, 10)
                    Spacer()
                    Text("Hard")
                     .font(.body)
                     .foregroundColor(.secondary)
                     
                }
                
                if let description = plant.description {
                    Text("Description")
                        .font(.headline)
                        .foregroundColor(.primaryGreen)
                        .padding(.top, 10)
                    
                    Text(description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                
                if let benefits = plant.benefits {
                    Text("Benefits")
                        .font(.headline)
                        .foregroundColor(.primaryGreen)
                        .padding(.top, 10)
                    
                    Text(benefits)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
        .padding(16)
        .frame(width: 351, alignment: .leading)
        .background(.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 0)
        .frame(width: 351, height: 533)
    }
}

#Preview {
    PlantCardView(plant: Tomato)
}
