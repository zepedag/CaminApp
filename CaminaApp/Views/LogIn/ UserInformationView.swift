import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct UserInformationView: View {
    
    @State private var age = ""
    @State private var height = ""
    @State private var weight = ""
    @State private var isShowingNavBar = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    private var databaseRef: DatabaseReference = Database.database().reference()
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                Text("Complete Your Profile")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryGreen)
                    .padding(.top, 40)
                
                VStack(spacing: 20) {
                    FormNumberField(label: "Age (years)", text: $age)
                    FormNumberField(label: "Height (meters)", text: $height)
                    FormNumberField(label: "Weight (kg)", text: $weight)
                }
                .padding(.horizontal, 32)
                
                Button(action: completeRegistration) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Finish Setup")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, 32)
                .disabled(isLoading)
                
                Spacer()
            }
            
            if isLoading {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        )
            }
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .navigationDestination(isPresented: $isShowingNavBar) {
            NavigationBar()
        }
        .accentColor(Color.primaryGreen)
        .navigationBarBackButtonHidden(true)
    }
    
    private func completeRegistration() {
        // Validate fields
        guard !age.isEmpty, !height.isEmpty, !weight.isEmpty else {
            alertMessage = "Please fill in all fields"
            showAlert = true
            return
        }
        
        // Convert and validate numbers
        guard let ageValue = Int(age), ageValue > 0, ageValue <= 120 else {
            alertMessage = "Please enter a valid age (1-120)"
            showAlert = true
            return
        }
        
        guard let heightValue = Double(height.replacingOccurrences(of: ",", with: ".")),
              heightValue > 0.5, heightValue < 2.5 else {
            alertMessage = "Please enter a valid height (0.5-2.5 meters)"
            showAlert = true
            return
        }
        
        guard let weightValue = Double(weight.replacingOccurrences(of: ",", with: ".")),
              weightValue > 20, weightValue < 300 else {
            alertMessage = "Please enter a valid weight (20-300 kg)"
            showAlert = true
            return
        }
        
        guard let userID = Auth.auth().currentUser?.uid else {
            alertMessage = "User not authenticated"
            showAlert = true
            return
        }
        
        isLoading = true
        
        // Prepare numeric data
        let userData: [String: Any] = [
            "age": ageValue,
            "height": heightValue,
            "weight": weightValue,
            "profileCompleted": true,
            "updatedAt": ServerValue.timestamp()
        ]
        
        // Save to Firebase
        databaseRef.child("users").child(userID).updateChildValues(userData) { error, _ in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    alertMessage = "Save failed: \(error.localizedDescription)"
                    showAlert = true
                } else {
                    isShowingNavBar = true
                }
            }
        }
    }
}

struct FormNumberField: View {
    let label: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            TextField("", text: $text)
                .keyboardType(.decimalPad)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.primaryGreen, lineWidth: 1)
                )
                .onChange(of: text) { newValue in
                    // Filter non-numeric characters and allow single decimal point
                    let filtered = newValue.filter { "0123456789.".contains($0) }
                    let components = filtered.components(separatedBy: ".")
                    
                    if components.count > 2 {
                        text = String(filtered.dropLast())
                    } else if filtered != newValue {
                        text = filtered
                    }
                }
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.primaryGreen)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}



// Preview
struct UserInformationView_Previews: PreviewProvider {
    static var previews: some View {
        UserInformationView()
    }
}


