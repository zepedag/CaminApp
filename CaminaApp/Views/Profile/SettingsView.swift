import SwiftUI

struct SettingsView: View {
    @State private var username: String = ""
    @State private var fullName: String = ""
    @State private var joinedDate: String = ""
    @State private var isDarkMode: Bool = false
    @State private var letterSize: Double = 14
    @State private var language: String = "EN"
    @State private var city: String = ""

    var body: some View {
            Form {
                Section(header: Text("USER INFORMATION")) {
                    HStack {
                        Image(systemName: "person.crop.circle.fill") // Reemplaza esto con tu imagen
                            .resizable()
                            .frame(width: 50, height: 50)
                        TextField("Username", text: $username)
                    }
                    TextField("Full Name", text: $fullName)
                    TextField("City", text: $city)
                }
                
                Section(header: Text("PRIVACY AND SECURITY")) {
                    Button(action: {
                    }) {
                        Text("Save")
                            .foregroundColor(Color.primaryGreen)
                    }
                    Button(action: {
                    }) {
                        HStack {
                            Text("Change password")
                                .foregroundColor(Color.primaryGreen)
                            Spacer()
                            Text("Last changed: 3 weeks ago")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Button(action: {
                    }) {
                        Text("Log out")
                            .foregroundColor(Color.primaryGreen)
                    }
                    
                }
            }
            .navigationBarTitle("Settings")
            .accentColor(Color.primaryGreen)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .navigationBarBackButtonHidden(false)
    }
}
