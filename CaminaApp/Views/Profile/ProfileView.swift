import SwiftUI

struct ProfileView: View {
    var user: User
    @State private var isShowingSettings = false
    
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(spacing: 10) {
                    NavigationLink(destination: SettingsView(), isActive: $isShowingSettings) { EmptyView() }
                    
                    user.profilePicture
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .padding(.top, 20)
                    
                    Text(user.fullName)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("@\(user.username)")
                        .font(.subheadline)
                        .foregroundColor(.darkGreen.opacity(0.6))
                    
                    HStack{
                        Image(systemName: "location.fill")
                            .foregroundColor(.primaryGreen)
                        Text(user.location)
                    }
                        .font(.subheadline)
                        .padding(.top, 0)
                    
                    // Personal details
                    GroupBox(label: Label("About Me", systemImage: "person.crop.circle")
                                .foregroundColor(.primaryGreen)) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(user.bio)")
                                .font(.body)
                            
                            Divider()
                            
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.primaryGreen)
                                Text(user.email)
                                    .font(.callout)
                            }
                            
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.primaryGreen)
                                Text("\(user.age) years")
                                    .font(.callout)
                            }
                        }
                    }
                    .padding()
                    
                    // Badges
                    HStack(spacing: 15) {
                        BadgeView(text: "Gardener Pro")
                        BadgeView(text: "Plant Lover")
                    }
                    .padding(.top, 0)
                }
                .padding()
            }
            .navigationBarItems(trailing: Button(action: {
                isShowingSettings = true
            }) {
                Image(systemName: "gear")
            })
            .navigationBarTitle("My profile", displayMode: .inline)
        }
        .accentColor(Color.primaryGreen)
    }
    
}

// Mantenemos BadgeView igual por simplicidad y consistencia
struct BadgeView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .padding(8)
            .background(Color.green.opacity(0.1))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.primaryGreen, lineWidth: 2)
            )
    }
}



struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleUsers = generateExampleUsers()
        ProfileView(user: exampleUsers.first!) // Utilizamos el primer usuario generado para el preview
            .previewLayout(.sizeThatFits)
    }
}
