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


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
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

extension UIImageView {
    func enableZoom() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
    isUserInteractionEnabled = true
    addGestureRecognizer(pinchGesture)
  }

  @objc
  private func startZooming(_ sender: UIPinchGestureRecognizer) {
    let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
    guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
    sender.view?.transform = scale
    sender.scale = 1
    
  }

}
