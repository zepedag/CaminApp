import Foundation
import SwiftUI
import UIKit

extension Color {
    public static let primaryGreen = Color(hex: "#B90504")
    public static let darkGreen = Color(hex: "#990100")
    public static let cream = Color(hex: "#F6F6F6")
    public static let orange = Color(hex: "#E8E8E8")
    public static let brown = Color(hex: "#333333")
    public static let navyBlue = Color(hex: "#8D99AE")
    public static let mustardYellow = Color(hex: "#F0C086") 
    public static let opaqueRed = Color(hex: "#E06A6A")
    public static let lightGreen = Color(hex: "#B0C4B0")
    public static let deepBlue = Color(hex: "#7FA5AA")
    public static let darkorange = Color(hex: "#FF6600")
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        

        self.init(red: red, green: green, blue: blue)
    }
}
