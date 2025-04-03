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
            VStack(spacing: 30) {
                Text("Welcome to Antojo Activo")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.darkGreen)
                    .padding(.top, 10)
                Image("logoAntojoActivo")
                    .resizable()
                    .frame(height: 200)
                    .frame(width: 200)
                    .cornerRadius(12)
                
                // Campos de entrada
                VStack(spacing: 20) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(Color.cream)
                        .cornerRadius(8)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.cream)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 30)

                // Botones
                VStack(spacing: 15) {
                    Button(action: loginUser) {
                        Text("Login")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.brown)
                            .cornerRadius(12)
                    }

                    Button(action: {
                        isShowingSignUp = true
                    }) {
                        Text("Sign Up")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.navyBlue)
                            .cornerRadius(12)
                    }

                    Button(action: {
                        // Acción para autenticación biométrica
                    }) {
                        Text("Authenticate With Biometrics")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primaryGreen)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 30)
            }
            .padding(.bottom, 10) // Espacio inferior

            // Navegación
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

