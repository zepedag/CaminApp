import SwiftUI
import Charts

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
                    
                    // Achievements Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Achievements")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.leading, 10)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                AchievementView(icon:"figure.walk",text: "10,000\nSteps", color: .white)
                                AchievementView2(icon: "leaf.fill", text: "Vegan for\na Week", color: .white)
                                AchievementView3(icon: "fork.knife", text: "Tried 50\nDishes", color: .white)
                                AchievementView4(icon: "cup.and.saucer.fill", text: "Coffee\nEnthusiast", color: .white)
                                                            
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Progress Overview")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.leading, 10)
                            .padding(.top, 20)
                                           
                        Chart {
                            BarMark(x: .value("Category", "Steps"), y: .value("Progress", 80))
                                .foregroundStyle(.blue)
                            BarMark(x: .value("Category", "Vegan"), y: .value("Progress", 60))
                                .foregroundStyle(.green)
                            BarMark(x: .value("Category", "Dishes"), y: .value("Progress", 75))
                                .foregroundStyle(.orange)
                            BarMark(x: .value("Category", "Coffee"), y: .value("Progress", 90))
                                .foregroundStyle(.brown)
                        }
                        .frame(height: 200)
                        .padding(.horizontal, 20)
                }
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

// Achievement View
struct AchievementView: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(Color.mustardYellow)
                    .frame(width: 60, height: 60)
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(color)
            }
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
    }
}
struct AchievementView2: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(Color.deepBlue)
                    .frame(width: 60, height: 60)
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(color)
            }
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
    }
}
struct AchievementView3: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(Color.opaqueRed)
                    .frame(width: 60, height: 60)
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(color)
            }
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
    }
}
struct AchievementView4: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(Color.lightGreen)
                    .frame(width: 60, height: 60)
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(color)
            }
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleUsers = generateExampleUsers()
        ProfileView(user: exampleUsers.first!)
            .previewLayout(.sizeThatFits)
    }
}

