import Foundation
import SwiftUI

struct LogInView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Welcome to Cultivise")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.primaryGreen)
                .padding()
            
            Image("huerto_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 150, maxHeight: 150)
                .padding()
            
            VStack(spacing: 20) {
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.cream)
                    .cornerRadius(8.0)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.cream)
                    .cornerRadius(8.0)
            }
            .padding(.horizontal)
            
            Button(action: {
                // TODO: Add validation for sign up
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.primaryGreen)
                    .cornerRadius(8.0)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .foregroundColor(Color.darkGreen)
    }
}

#Preview {
    LogInView()
}
