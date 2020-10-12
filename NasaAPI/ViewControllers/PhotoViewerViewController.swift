//
//  PhotoViewerViewController.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 10/10/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class PhotoViewerViewController: UIViewController {

    let imageView: UIImageView = {
        let field = UIImageView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.contentMode = .scaleAspectFit
        field.backgroundColor = .clear
        field.clipsToBounds = true
//        field.enableZoom()
        return field
    }()
    
    let scrollView: UIScrollView = {
        let field = UIScrollView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.minimumZoomScale = 1.0
        field.maximumZoomScale = 5.0
        return field
    }()
    
    init(image: UIImage) {
        self.imageView.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 400)
        ])
        scrollView.delegate = self
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
//        scrollView.contentSize = CGSize(width: view.frame.width*4, height: view.frame.height)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedBackground))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
    }
    
    @objc func tappedBackground() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension PhotoViewerViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
