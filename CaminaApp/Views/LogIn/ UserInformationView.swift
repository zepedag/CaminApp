import SwiftUI

struct UserInformationView: View {
    @State private var age = ""
    @State private var height = ""
    @State private var weight = ""
    @State private var isShowingNavBar = false
    var user: UserData
    
    var body: some View {
        VStack(spacing: 80) {
            Text("Complete Your Profile")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primaryGreen)
                .padding(.top, 50)

            VStack(spacing: 16) {
                FormNumberField(label: "Age", text: $age)
                FormNumberField(label: "Height (M)", text: $height)
                FormNumberField(label: "Weight (kg)", text: $weight)
            }
            .padding(.horizontal, 32)
            
            Button(action: {
                completeRegistration()
                isShowingNavBar = true
            }) {
                Text("Finish Setup")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
            }
            .buttonStyle(PrimaryActionStyle())
            .padding(.horizontal, 32)
            
            Spacer()
        }
        .background(Color(.systemBackground))
        .navigationDestination(isPresented: $isShowingNavBar) {
            NavigationBar()
        }
        .accentColor(Color.primaryGreen)
    }
    
    private func completeRegistration() {
        print("User registered: \(user.firstName)")
        print("Additional info: Age \(age), Height \(height), Weight \(weight)")
    }
}

struct FormNumberField: View {
    let label: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.body)
                .foregroundColor(.primary)
            
            TextField("", text: $text)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.cream)
                .cornerRadius(8)
        }
    }
}

