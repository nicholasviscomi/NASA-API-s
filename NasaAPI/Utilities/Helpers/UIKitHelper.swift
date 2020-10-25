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

func reverseArray(array: [APOD]) -> [APOD] {
    var arr = [APOD]()
    
    for apod in array {
        arr.insert(apod, at: 0)
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
