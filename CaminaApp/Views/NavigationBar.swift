import SwiftUI

struct NavigationBar: View {
    @State private var selectedTab = 1
    
    let users = generateExampleUsers()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SocialGeneralView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Social")
                }
                .tag(0)
            
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(1)
            
            ProfileView(user: users.first!)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(2)
        }
        .accentColor(Color.primaryGreen)
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar()
    }
}


