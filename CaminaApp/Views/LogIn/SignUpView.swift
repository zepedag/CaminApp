import SwiftUI

struct UserData {
    var firstName: String = ""
    var email: String = ""
    var password: String = ""
}

struct SignUpView: View {
    @State private var user = UserData()
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showUserInfo = false
    @State private var isShowingUserInfo = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 60) {
                Text("Create an Account")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primaryGreen)
                    .padding(.top, 50)
                
                VStack(spacing: 16) {
                    FormTextField(label: "First Name", text: $user.firstName)
                    FormTextField(label: "Email", text: $user.email)
                        .keyboardType(.emailAddress)
                    FormSecureField(label: "Password", text: $user.password)
                    FormSecureField(label: "Confirm Password", text: $confirmPassword)
                }
                .padding(.horizontal, 32)
                
                Button(action: {
                    isShowingUserInfo = true
                }) {
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
            UserInformationView(user: user)
        }
        .accentColor(Color.primaryGreen)
        
    }
    private func validateRegistration() {
        guard !user.password.isEmpty && user.password == confirmPassword else {
            alertMessage = "Passwords don't match"
            showAlert = true
            return
        }
        showUserInfo = true
    }
        
}


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


