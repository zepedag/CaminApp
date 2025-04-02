import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct UserInformationView: View {
    var user: UserData  // <- Asegurar que no es private

    @State private var age = ""
    @State private var height = ""
    @State private var weight = ""
    @State private var isShowingNavBar = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    private var databaseRef: DatabaseReference = Database.database().reference()

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

            Button(action: completeRegistration) {
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
        .alert("Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .navigationDestination(isPresented: $isShowingNavBar) {
            NavigationBar()
        }
        .accentColor(Color.primaryGreen)
    }

    init(user: UserData) {  // <- Asegurar que el inicializador sea público
        self.user = user
    }

    private func completeRegistration() {
        guard let userID = Auth.auth().currentUser?.uid else {
            alertMessage = "No authenticated user"
            showAlert = true
            return
        }

        let additionalInfo = [
            "age": age,
            "height": height,
            "weight": weight
        ]

        databaseRef.child("users").child(userID).updateChildValues(additionalInfo) { error, _ in
            if let error = error {
                alertMessage = "Database error: \(error.localizedDescription)"
                showAlert = true
            } else {
                isShowingNavBar = true
            }
        }
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

