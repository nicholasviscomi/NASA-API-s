//
//  UIKitHelper.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 10/19/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit
import SafariServices

func openVideo(with model: APOD, viewController: UIViewController) {
    if let videoUrl = model.videoUrl, let url = NSURL(string: videoUrl) {
        if UIApplication.shared.canOpenURL(url as URL) {
            let vc = SFSafariViewController(url: url as URL)
            viewController.present(vc, animated: true, completion: nil)
        } else {
            showAlert(title: "Invalid URL", message: "Video URL was unable to be opened", view: viewController)
            print("cannot open URL: \(videoUrl)")
        }
    }
}

func showAlert(title: String, message: String, view: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
    
    view.present(alert, animated: true, completion: nil)
}

func canOpenUrl(url: URL) -> Bool {
    return UIApplication.shared.canOpenURL(url)
}

func reverseArray<T>(array: [T]) -> [T] {
    var arr = [T]()
    
    for item in array {
        arr.insert(item, at: 0)
    }
    
    return arr
}

extension CALayer {
    func removeLayerIfExists(_ view: UIView) {
        if let lastLayer = view.layer.sublayers?.last {
            let isPresent = lastLayer is ShimmerLayer
            if isPresent {
                self.removeFromSuperlayer()
            }
        }
    }
}

func addBG(color: UIColor, VCView: UIView, view: UIView, padding: CGFloat) {
    let bg = UIView()
    bg.backgroundColor = color
    bg.frame = CGRect(x: view.frame.origin.x - padding, y: view.frame.origin.y - padding, width: view.frame.width + padding, height: view.frame.height + padding)

    VCView.addSubview(bg)
}

func datesFor(count: Int) -> [String] {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    var result = [String]()
    
    for i in 0..<count {
        let date = Date().addingTimeInterval(TimeInterval(86400 * (i * -1)))
        result.append(formatter.string(from: date))
    }
    
    return result
}

func numOfDaysInMonth(date: Date) -> Int {
//    let dateComponents = DateComponents(year: 2015, month: 7)
    let calendar = Calendar.current

    let range = calendar.range(of: .day, in: .month, for: date)!
    let numDays = range.count

    return numDays
}

func lastThreeMonths() -> [String]? {
    guard let current = Calendar.current.date(byAdding: .month, value: 0, to: Date()),
          let previous = Calendar.current.date(byAdding: .month, value: -1, to: Date()),
          let prevPrevious = Calendar.current.date(byAdding: .month, value: -2, to: Date())
    else { return nil }
    
    let fmt = DateFormatter()
    fmt.dateStyle = .long
    let currMonth = fmt.string(from: current).split(separator: " ")[0]
    let prevMonth = fmt.string(from: previous).split(separator: " ")[0]
    let prevPrevMonth = fmt.string(from: prevPrevious).split(separator: " ")[0]

    return [String(currMonth), String(prevMonth), String(prevPrevMonth)]
    
}
