import Foundation
import SwiftUI


struct Garden {
    var id: UUID
    var name: String
    var gardenpic: Image
    var description: String
    var location: String
    var numberOfPlants: Int
    var plants: [MyPlant]
    var trees: [Tree]
    var soilType: SoilType
    var sunlightLevel: SunlightLevel
    var setting: GardenSetting
    
    var myLog: [GardenActivityLog]?
    
}

struct GardenActivityLog: Identifiable{
    var id: UUID
    var title: String
    var description: String
    var date: Date
    var daysFromCreation: Int {
            return Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
        }
}


