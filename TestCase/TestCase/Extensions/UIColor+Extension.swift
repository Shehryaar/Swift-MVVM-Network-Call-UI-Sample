//
//  UIColor+Extension.swift
//  TestCase
//
//  Created by Shehryar on 15/04/2021.
//

import UIKit

extension UIColor {
    static let background_1 = UIColor(named: "Background_1")!
    static let tint_1 = UIColor(named: "Tint_1")!
    static let tint_2 = UIColor(named: "Tint_2")!
    static let tint_3 = UIColor(named: "Tint_3")!
    static let tint_4 = UIColor(named: "Tint_4")!
    static let tint_5 = UIColor(named: "Tint_5")!
    static let tint_6 = UIColor(named: "Tint_6")!
    static let tint_7 = UIColor(named: "Tint_7")!
    static let tint_8 = UIColor(named: "Tint_8")!
    static let tint_9 = UIColor(named: "Tint_9")!
    static let tint_10 = UIColor(named: "Tint_10")!
    
    static let Gray = UIColor(named: "Gray")!
}

extension UIColor {
    public convenience init(rgb: (r: CGFloat, g: CGFloat, b: CGFloat)) {
        self.init(red: rgb.r/255, green: rgb.g/255, blue: rgb.b/255, alpha: 1.0)
    }
}

extension UIColor{
    
    /// Converting hex string to UIColor
    ///
    /// - Parameter hexString: input hex string
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

