//
//  Colors.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 10/13/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

struct Colors {
    static let NasaBlue = UIColor(red: 0.34, green: 0.41, blue: 0.54, alpha: 1.00)
    static let textNasaBlue = UIColor(red: 0.43, green: 0.53, blue: 0.69, alpha: 1.00)
    static let contrastBlue = UIColor(red: 0.41, green: 0.57, blue: 0.71, alpha: 1.00)
    
    static let skyGreen = UIColor(red: 0.42, green: 0.53, blue: 0.54, alpha: 1.00)
    static let skyBrown = UIColor(red: 0.58, green: 0.58, blue: 0.42, alpha: 1.00)
    
    static let skyPink = UIColor(red: 0.73, green: 0.51, blue: 0.46, alpha: 1.00)
    static let softBg = UIColor(red: 0.20, green: 0.11, blue: 0.06, alpha: 1.00)
    static let softPurple = UIColor(red: 0.59, green: 0.49, blue: 0.56, alpha: 1.00)
    static let lightGray = UIColor(red: 0.39, green: 0.39, blue: 0.45, alpha: 1.00)
}

func semanticColor(light: UIColor, dark: UIColor) -> UIColor {
    if #available(iOS 13, *) {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return dark
            } else if traitCollection.userInterfaceStyle == .light {
                return light
            } else {
                return light
            }
        }
    }
    return dark
}

extension UIColor {
    static let cellBg = semanticColor(light: Colors.lightGray, dark: Colors.skyPink)
    static let textNasaBlue = Colors.textNasaBlue
    static let contrastBlue = Colors.contrastBlue
    static let skyBrown = Colors.skyBrown
    static let softBg = semanticColor(light: Colors.softPurple, dark: Colors.softBg)
    static let softPurple = Colors.softPurple
}


