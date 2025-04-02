import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct LogInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isShowingSignUp = false
    @State private var isShowingNavBar = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 80) {
                Text("Welcome to CaminaApp")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primaryGreen)
                    .padding(.top, 100)

                VStack(spacing: 30) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(Color.cream)
                        .cornerRadius(8.0)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.cream)
                        .cornerRadius(8.0)
                }
                .padding(.horizontal, 35)
                .padding(.bottom, 60)
            }
            VStack (spacing: 20){
                Button(action: loginUser) {
                    Text("Login")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.brown)
                        .cornerRadius(20.0)
                        .padding(.horizontal)
                }
                .padding(.vertical, 0)

                Button(action: {
                    isShowingSignUp = true
                }) {
                    Text("SignUp")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.navyBlue)
                        .cornerRadius(20.0)
                        .padding(.horizontal)
                }
                Button(action: {
                }) {
                    Text("Authenticate With Biometrics")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.primaryGreen)
                        .cornerRadius(20.0)
                        .padding(.horizontal)
                }
                .padding(.bottom, 70)
            }
            .foregroundColor(Color.darkGreen)
            .navigationDestination(isPresented: $isShowingNavBar) {
                NavigationBar()
            }
            .navigationDestination(isPresented: $isShowingSignUp) {
                SignUpView()
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
        .accentColor(Color.primaryGreen)
    }

    private func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertMessage = "Error: \(error.localizedDescription)"
                showAlert = true
                return
            }

            isShowingNavBar = true
        }
    }
}

#Preview {
    LogInView()
}

