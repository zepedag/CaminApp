import SwiftUI

struct GeneralGardenView: View {
    @State private var showingTipsSheet = false
    @State private var showingPlantsSheet = false
    @State private var showingARView = false
    var garden: Garden
    
    var body: some View {
        ZStack(alignment: .top) {
            garden.gardenpic
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 393, height: 345)
                .clipped()
            
            LinearGradient(
                stops: [
                    .init(color: Color(red: 0.38, green: 0.42, blue: 0.22).opacity(0.1), location: 0.00),
                    .init(color: Color(red: 0.97, green: 0.97, blue: 0.97).opacity(0.1), location: 0.83),
                    .init(color: .white, location: 1.00)
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
            .frame(width: 393, height: 345)
            ScrollView {
                VStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 345 / 2)
                    
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                self.showingTipsSheet = true
                            }) {
                                GardenTipsView(garden: garden)
                            }
                            .sheet(isPresented: $showingTipsSheet) {
                                // Present your tips view here
                            }
                            NavigationLink(destination: GardenView(garden: garden), isActive: $showingPlantsSheet) {
                                GardenPlantsView(garden: garden)
                            }
                            Spacer()
                        }
                        .padding(21)
                         
                        VRView(showingARView: $showingARView)
                        
                        LogCardGardenView(garden: garden)
                            .padding(.horizontal, 21)
                    }
                    .offset(y: 20)
                }
            }
        }
        .navigationTitle("\(garden.name)")
        .frame(width: 393, alignment: .top)
        .accentColor(.primaryGreen)
        .sheet(isPresented: $showingTipsSheet) {
            //NewTipsView()
        }
    }
}

struct GardenTipsView: View {
    var garden: Garden
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Tips")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
            Spacer()
            
            HStack(alignment: .center, spacing: 0) {
                Image(systemName: "lightbulb")
                    .font(.system(size: 30))
                    .frame(width: 29.86099, height: 26.35941)
            }
            .padding(.leading, 102.88396)
            .padding(.trailing, 0.25504)
            .padding(.top, 71)
            .padding(.bottom, 1.64059)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(.white.opacity(0.75))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 0)
    }
    
    
}

struct GardenPlantsView: View {
    var garden: Garden
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Plants")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
            Spacer()
            
            HStack(alignment: .center, spacing: 0) {
                Image(systemName: "leaf")
                    .font(.system(size: 30))
                    .frame(width: 29.86099, height: 26.35941)
            }
            .padding(.leading, 102.88396)
            .padding(.trailing, 0.25504)
            .padding(.top, 71)
            .padding(.bottom, 1.64059)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 0)
    }
}

struct VRView: View {
    @Binding var showingARView: Bool

    var body: some View {
        ZStack {
           
            // Your actual clickable HStack
            HStack(alignment: .center, spacing: 20) {
                // The entire HStack is inside a Button
                Button(action: {
                    self.showingARView = true
                }) {
                    HStack{
                        Image(systemName: "camera.viewfinder")
                            .font(.system(size: 50))
                    }
                    .background(Color.white)
                }
            }
        }
    }
}


struct LogCardGardenView: View {
    var garden: Garden
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Activity")
                    .font(.title2.bold())
                    .foregroundColor(.black)
                
                Spacer()
                
                Button("Dismiss") {
                    // Empty log
                }
                .foregroundColor(.primaryGreen)
                .padding()
                .background(Color.primaryGreen.opacity(0.15))
                .cornerRadius(10)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            
            // ScrollView should allow scrolling through all the logs
            ScrollView {
                if let log = garden.myLog, !log.isEmpty {
                    ForEach(log) { log in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(log.title)
                                    .italic()
                                    .foregroundColor(.primaryGreen)
                                
                                Spacer()
                                
                                Text("\(log.daysFromCreation) days ago")
                                    .font(.caption)
                                    .foregroundColor(.primaryGreen)
                            }
                            
                            Text(log.description)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.top, 2)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.primaryGreen.opacity(0.15))
                        .cornerRadius(12)
                        .shadow(radius: 4)
                    }
                } else {
                    // Show a message when there are no logs
                    Text("No activity yet")
                        .foregroundColor(.gray)
                        .italic()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                }
            }
            .padding(.horizontal)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 0)
        .padding(21)
    }
}


struct GeneralGardenView_Previews: PreviewProvider {
    static var previews: some View {
        // Generar usuarios y seleccionar un jardín de ejemplo
        let exampleGarden = generateExampleUsers().first?.gardens.first!
        
        // Pasar el jardín de ejemplo a GardenView
        GeneralGardenView(garden: exampleGarden!)
    }
}
