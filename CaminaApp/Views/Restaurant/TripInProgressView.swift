import SwiftUI

struct TripInProgressView: View {
    let menu: [Dish]
    let destinationName: String
    @State private var isShowingTripSumm = false
    @State private var isShowingCamera = false
    @State private var dotCount = 0

    var animatedDots: String {
        String(repeating: ".", count: dotCount) // Alterna entre "", ".", "..", "..."
    }

    var body: some View {
        VStack {
            // Animación de persona caminando
            WalkingAnimationView()
                .frame(height: 300)
                .padding(.bottom, -40)
            
            Text("Going to \(destinationName)")
                .font(.headline)
                .foregroundColor(.black)
                .padding(.bottom, 5)
            
            // "Trip in progress" fijo con puntos animados dentro de un ancho constante
            HStack(spacing: 0) {
                Text("Trip in progress") // Texto fijo
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                Text(animatedDots) // Puntos animados con ancho fijo
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .frame(width: 30) // Mantiene un ancho fijo para evitar movimientos
            }
            .multilineTextAlignment(.center)
            .padding(.bottom, 40)
            .onAppear {
                startAnimatingDots()
            }
            
            // Menú del restaurante
            RestaurantMenuView(menu: menu)
                .padding(.bottom, 10)
            
            // Texto para indicar que puedes elegir
            Text("OR")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.bottom, 10)
            
            // Botón para abrir la cámara
            Button(action: {
                isShowingCamera = true
            }) {
                HStack {
                    Image(systemName: "camera.fill")
                    Text("Take a photo")
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.primaryGreen)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .sheet(isPresented: $isShowingCamera) {
                CameraView()
            }
            Button(action: {
                isShowingTripSumm = true
            }) {
                HStack {
                    Image(systemName: "flag.checkered")
                    Text("Finish Trip")
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.brown)
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }
        .navigationDestination(isPresented: $isShowingTripSumm) {
            TripSummaryView()
        }
        .navigationTitle("En camino...")
    }
    
    // Función para animar solo los puntos sin mover el texto base
    private func startAnimatingDots() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            withAnimation {
                dotCount = (dotCount + 1) % 4 // Alterna entre 0, 1, 2 y 3 puntos
            }
        }
    }
}

#Preview {
    let sampleMenu: [Dish] = [
        Dish(name: "Tacos al Pastor", calories: 450, price: 14.99),
        Dish(name: "Chiles en Nogada", calories: 700, price: 169.99),
        Dish(name: "Mole Poblano", calories: 600, price: 129.99),
    ]

    return TripInProgressView(menu: sampleMenu, destinationName: "Santoua")
}

