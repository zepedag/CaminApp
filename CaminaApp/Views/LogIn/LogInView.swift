import SwiftUI

struct LogInView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isShowingSignUp = false
    @State private var isShowingNavBar = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 80) {
                Text("Welcome to CaminaApp")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primaryGreen)
                    .padding(.top, 100)

                VStack(spacing: 30) {
                    TextField("Username", text: $username)
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
                Button(action: {
                    isShowingNavBar = true
                }) {
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
        }
        .accentColor(Color.primaryGreen)
    }
}

#Preview {
    LogInView()
}


