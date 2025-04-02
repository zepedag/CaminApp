import CoreLocation

struct Restaurant: Identifiable {
    let id: UUID
    let name: String
    let foodType: String
    let distance: Double // in km
    let walkingTime: Int // in minutes
    let caloriesInFood: Int
    let coordinate: CLLocationCoordinate2D
    
    var caloriesBurned: Int {
        Int(Double(distance) * 60)
    }
    
    var caloriesPercentage: Double {
        min(Double(caloriesBurned) / Double(caloriesInFood), 1.0)
    }
}
