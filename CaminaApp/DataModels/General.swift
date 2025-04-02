import Foundation
import SwiftUI

enum SoilType {
    case normal(percentage: Int)
    case compost(percentage: Int)
    case wormHummus(percentage: Int)
}

enum SunlightLevel {
    case fullSun
    case partialShade
    case fullShade
}

enum WaterLevel {
    case high
    case medium
    case low
}

enum Difficulty {
    case easy
    case moderate
    case hard
}

enum GardenSetting {
    case pot
    case hydroponicSystem
    case raisedBed
}

enum Inout{
    case indoor
    case outdoor
}


func generateExampleUsers() -> [User] {
    let plantsData = [
        Plant(scientificName: "Phaseolus vulgaris", commonName: "Bean", alias: "Bean Stalker", recommendedSoil: .normal(percentage: 50), waterLevel: .low, sunlightLevel: .fullSun, difficulty: .easy, needsSupport: true, image: Image("beanimage")),
        Plant(scientificName: "Solanum tuberosum", commonName: "potato", alias: "Spud Buddy", recommendedSoil: .compost(percentage: 50), waterLevel: .medium, sunlightLevel: .partialShade, difficulty: .moderate, needsSupport: false, image: Image("potatoimage")),
        Plant(scientificName: "Solanum lycopersicum", commonName: "Tomato", alias: "Red Gem", recommendedSoil: .compost(percentage: 40), waterLevel: .medium, sunlightLevel: .fullSun, difficulty: .moderate, needsSupport: true, image: Image("tomatoimage")),
        Plant(scientificName: "Allium fistulosum", commonName: "Cambray onion", alias: "Green Spear", recommendedSoil: .wormHummus(percentage: 60), waterLevel: .low, sunlightLevel: .partialShade, difficulty: .easy, needsSupport: false, image: Image("onionimage")),
        Plant(scientificName: "Opuntia ficus-indica", commonName: "Prickly pear", alias: "Desert's Pride", recommendedSoil: .normal(percentage: 30), waterLevel: .low, sunlightLevel: .fullSun, difficulty: .easy, needsSupport: false, image: Image("pearimage")),
        Plant(scientificName: "Daucus carota subsp. sativus", commonName: "Carrot", alias: "Orange Crunch", recommendedSoil: .compost(percentage: 50), waterLevel: .medium, sunlightLevel: .fullSun, difficulty: .moderate, needsSupport: false, image: Image("tomatoimage")),
        Plant(scientificName: "Beta vulgaris", commonName: "Betabel", alias: "Beetroot", recommendedSoil: .wormHummus(percentage: 50), waterLevel: .medium, sunlightLevel: .partialShade, difficulty: .hard, needsSupport: false, image: Image("betabelimage"))
    ]
    
    let myPlants = plantsData.map { plant -> MyPlant in
            let activities = [PlantActivity(date: Date(), watered: true, sunExposure: true, dayImage: nil)]
        return MyPlant(myPlant: Tomato, dayOfCreation: Date(), myPlantActivity: activities)
        }
    
    

    let trees = [
        Tree(commonName: "Aguacate", scientificName: "Persea americana", alias: "Cate de mi cora", recommendedSoil: .wormHummus(percentage: 75), waterLevel: .high, sunlightLevel: .fullSun, difficulty: .hard),
           Tree(commonName: "Limón", scientificName: "Citrus × limon", alias: "Mr Lemon",  recommendedSoil: .normal(percentage: 50), waterLevel: .medium, sunlightLevel: .fullSun, difficulty: .easy),
           Tree(commonName: "Naranja", scientificName: "Citrus × sinensis", alias: "Nara Manja",  recommendedSoil: .normal(percentage: 60), waterLevel: .high, sunlightLevel: .fullSun, difficulty: .moderate),
           Tree(commonName: "Mandarina", scientificName: "Citrus reticulata", alias: "Manda la nana",  recommendedSoil: .compost(percentage: 40), waterLevel: .medium, sunlightLevel: .fullSun, difficulty: .moderate)
    ]
    
    let descriptions = [
        "A serene oasis filled with exotic flowers and a tranquil pond.",
        "A vibrant vegetable garden boasting a variety of seasonal produce.",
        "A cottage garden with winding paths, fragrant herbs, and colorful perennials.",
        "A modern rooftop garden featuring sleek design and urban greenery."
    ]
    
    let usersInfo = [
        (name: "Megan Montiel", bio: "I love chicken and tulips", email: "Megan@example.com"),
        (name: "Ana Mandujano", bio: "I love making bread and cooking", email: "AnaLau@example.com"),
        (name: "Ivan Nicolas", bio: "I love making music, sometimes", email: "Ivan@example.com")
    ]
    
    var users: [User] = []

    // Predefined sets of plants and trees for each garden
    let gardenPlants: [[MyPlant]] = [
            Array(myPlants[0...2]), // Garden 1
            Array(myPlants[2...5]), // Garden 2
            Array(myPlants[5...6])  // Garden 3
        ]
    
    let gardenTrees = [
        [trees[0]], // Garden 1
        [trees[1]], // Garden 2
        [trees[2]]  // Garden 3
    ]

    for (index, userInfo) in usersInfo.enumerated() {
        var gardens: [Garden] = []

        for gardenIndex in 0..<3 {
            let descriptionIndex = gardenIndex % descriptions.count
            
            gardens.append(
                Garden(
                    id: UUID(),
                    name: "Garden \(gardenIndex + 1)",
                    gardenpic: Image("garden\(gardenIndex + 1)"), // Ensure these images exist
                    description: descriptions[descriptionIndex],
                    location: "Backyard",
                    numberOfPlants: gardenPlants[gardenIndex].count + gardenTrees[gardenIndex].count,
                    plants: gardenPlants[gardenIndex],
                    trees: gardenTrees[gardenIndex],
                    soilType: .compost(percentage: 50),
                    sunlightLevel: .fullSun,
                    setting: .pot
                )
            )
        }
        
        users.append(User(id: UUID(), username: usersInfo[index].name, age: 20 + index, profilePicture: Image("profilePic\(index)"), fullName: userInfo.name, email: userInfo.email, bio: userInfo.bio, location: "Puebla", gardens: gardens))
    }

    return users
}
let exampleUsers = generateExampleUsers()
