import SwiftUI

struct PlantMiniCardView: View {
    var plant: MyPlant

    @State private var navigateToPlantView = false
    
    var body: some View {
        Button(action: {
            navigateToPlantView = true
        }) {
            VStack {
                Spacer()
                NavigationLink(destination: GeneralPlantView(plant: plant), isActive: $navigateToPlantView) { EmptyView() }
                Image(systemName: "leaf.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.primaryGreen)
                
                Spacer()
                
                Text(plant.myPlant.alias)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(alignment: .center)
                
                Spacer()
            }
            .padding(10)
            .frame(width: 100, height: 100)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.4), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TreeCardView: View {
    var tree: Tree

    @State private var navigateToTreeView = false
    
    var body: some View {
        Button(action: {
            navigateToTreeView = true
        }) {
            VStack (alignment: .center) {
                Spacer()
                
                NavigationLink(destination: TreeView(tree: tree), isActive: $navigateToTreeView) { EmptyView() }
                Image(systemName: "tree.circle.fill") // Ícono sugerido para árboles, siéntete libre de cambiarlo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.primaryGreen)
                
                Spacer()

                Text(tree.alias)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(alignment: .center)
                
                Spacer()
            }
            .padding(10)
            .frame(width: 100, height: 100)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.4), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}



struct PlantCardView_Previews: PreviewProvider {
    static var previews: some View {
        PlantMiniCardView(plant: myTomato)
    }
}

