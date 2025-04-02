import SwiftUI

struct Notification: Identifiable {
    let id: UUID
    let title: String
    let message: String
    
    init(title: String, message: String) {
        self.id = UUID()
        self.title = title
        self.message = message
    }
}

struct NotificationView: View {
    @State var notifications: [Notification] = [
        Notification(title: "Welcome", message: "Thanks for joining our service!"),
        Notification(title: "Update", message: "Version 2.0 is out now! Check it out."),
        Notification(title: "Reminder", message: "Your subscription is about to expire."),
        Notification(title: "Sale", message: "Upcoming weekend sale starting this Friday!"),
        Notification(title: "Feature", message: "We have added new features in your favorite app.")
    ]
    
    var body: some View {
        List {
            ForEach(notifications) { notification in
                VStack(alignment: .leading) {
                    Text(notification.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryGreen)
                    Text(notification.message)
                        .font(.caption)
                }
                .listRowBackground(Color.primaryGreen.opacity(0.15))
            }
            .onDelete(perform: delete)
        }
        .padding(.top, 20)
        .navigationTitle("Notifications")
        .scrollContentBackground(.hidden)
    }
    
    func delete(at offsets: IndexSet) {
        notifications.remove(atOffsets: offsets)
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
