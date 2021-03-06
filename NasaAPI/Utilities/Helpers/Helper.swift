//
//  Helper.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 9/21/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

public func blurBackground(for view: UIView, style: UIBlurEffect.Style) -> UIVisualEffectView {
    let blurEffect = UIBlurEffect(style: style)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = view.frame
    return blurEffectView
}

public func dataFrom(url: URL) -> Data? {
    if let data = try? Data(contentsOf: url), UIImage(data: data) != nil {
        return data
    } else {
        return nil
    }
}

public func imageFrom(data: Data) -> UIImage? {
    return UIImage(data: data)
}

func currentDateString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: Date())
}

func currentDate() -> Date {
    return Date()
}

func convert(string: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.date(from: string)
}

func string(from: Date) -> String? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: from)
}

func imageData(from image: UIImage) -> Data? {
    if let data = image.jpegData(compressionQuality: 0.5) { return data } else { return nil }
}
