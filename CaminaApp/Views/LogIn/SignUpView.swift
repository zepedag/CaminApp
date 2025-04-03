import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct UserData {
    var firstName: String = ""
    var email: String = ""
    var password: String = ""
    var age: Int = 0
    var height: Double = 0
    var weight: Double = 0
}

struct SignUpView: View {
    @State public var user = UserData()
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isShowingUserInfo = false
    
    public var databaseRef: DatabaseReference = Database.database().reference()

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Text("Create an Account")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primaryGreen)
                    .padding(.top, 50)

                VStack(spacing: 16) {
                    FormTextField(label: "First Name", text: $user.firstName)
                    FormTextField(label: "Email", text: Binding(
                                            get: { user.email },
                                            set: { user.email = $0.lowercased() } //
                                        ))
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                        .textInputAutocapitalization(.never)
                    FormSecureField(label: "Password", text: $user.password)
                    FormSecureField(label: "Confirm Password", text: $confirmPassword)
                }
                .padding(.horizontal, 32)

                Button(action: registerUser) {
                    Text("Create Account")
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
        }
        .navigationDestination(isPresented: $isShowingUserInfo) {
            UserInformationView()
        }
        .accentColor(Color.primaryGreen)
    }
    
    private func registerUser() {
        guard !user.password.isEmpty, user.password == confirmPassword else {
            alertMessage = "Passwords don't match"
            showAlert = true
            return
        }
        
        Auth.auth().createUser(withEmail: user.email, password: user.password) { authResult, error in
            if let error = error {
                alertMessage = "Error: \(error.localizedDescription)"
                showAlert = true
                return
            }
            
            guard let userID = authResult?.user.uid else { return }
            
            // En SignUpView, dentro de registerUser():
            let userData = [
                "firstName": user.firstName,
                "email": user.email
            ]

            databaseRef.child("users").child(userID).setValue(userData)
            
            databaseRef.child("users").child(userID).setValue(userData) { error, _ in
                if let error = error {
                    alertMessage = "Database error: \(error.localizedDescription)"
                    showAlert = true
                } else {
                    isShowingUserInfo = true
                }
            }
        }
    }
}

// Reutilización de componentes de UI
struct FormTextField: View {
    let label: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.body)
                .foregroundColor(.primary)

            TextField("", text: $text)
                .padding()
                .background(Color.cream)
                .cornerRadius(8)
        }
    }
}

struct FormSecureField: View {
    let label: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.body)
                .foregroundColor(.primary)

            SecureField("", text: $text)
                .padding()
                .background(Color.cream)
                .cornerRadius(8)
        }
    }
}

struct PrimaryActionStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .background(Color.primaryGreen)
            .cornerRadius(10)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

#Preview {
    SignUpView()
}
