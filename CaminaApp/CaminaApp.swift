import SwiftUI

@main
struct CaminaApp: App {
   
    init(){
        let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.titleTextAttributes = [.foregroundColor: UIColor(Color.black)]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.primaryGreen)]

                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            LogInView()
        }
    }
}
