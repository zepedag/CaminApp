import Foundation
import SwiftUI
import UIKit

extension Color {
    public static let white = Color(hex: "#F6F6F6")
    public static let gray = Color(hex: "#E8E8E8")
    public static let black = Color(hex: "#333333")
    public static let PrimaryRed = Color(hex: "#990100")
    public static let SecondRed = Color(hex: "#B90504")
    public static let navyBlue = Color(hex: "#003049")
    public static let mustardYellow = Color(hex: "#FFB703")
    public static let opaqueRed = Color(hex: "#C1121F")
    public static let lightGreen = Color(hex: "#A7C957")
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
