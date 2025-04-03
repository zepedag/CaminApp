import SwiftUI

struct TripInProgressView: View {
    let menu: [Dish]
    let destinationName: String
    @State private var isShowingTripSumm = false
    @State private var isShowingCamera = false
    @State private var dotCount = 0

    var animatedDots: String {
        String(repeating: ".", count: dotCount)
    }

    var body: some View {
        NavigationStack {
            VStack {
                WalkingAnimationView()
                    .frame(height: 300)
                    .padding(.bottom, -40)

                Text("Going to \(destinationName)")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.bottom, 5)

                HStack(spacing: 0) {
                    Text("Trip in progress")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)

                    Text(animatedDots)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .frame(width: 30)
                }
                .multilineTextAlignment(.center)
                .padding(.bottom, 40)
                .onAppear {
                    startAnimatingDots()
                }

                RestaurantMenuView(menu: menu)
                    .padding(.bottom, 10)

                Text("OR")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)

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

                NavigationLink(destination: TripSummaryView(restaurantName: destinationName), isActive: $isShowingTripSumm) {
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
            .accentColor(Color.primaryGreen)
        }
    }

    private func startAnimatingDots() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            withAnimation {
                dotCount = (dotCount + 1) % 4
            }
        }
    }
}

