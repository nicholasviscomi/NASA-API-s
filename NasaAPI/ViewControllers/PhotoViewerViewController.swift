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
        field.isScrollEnabled = true
        return field
    }()
    
    let model: APOD
    var image: UIImage
    
    init(model: APOD) {
        self.imageView.image = model.image!
        self.image = model.image!
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureRotation()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(sharePhoto))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(close))
    }
    
    func configure() {
        let style: UIBlurEffect.Style = traitCollection.userInterfaceStyle == .dark ? .systemUltraThinMaterialLight : .systemUltraThinMaterialDark
        let blur = blurBackground(for: view, style: style)
        blur.alpha = 1
        view.insertSubview(blur, at: 0)
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: view.frame.height)
        ])
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: view.frame.width),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.height)
        ])
    }
    
    fileprivate func configureRotation() {
        if imageView.frame.width > imageView.frame.height {
            imageView.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension PhotoViewerViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

extension PhotoViewerViewController: UIActivityItemSource {
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return UIImage(named: "Image")!
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        if activityType == .postToTwitter {
            
        }
        return image
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return model.title
    }
    
    @objc func sharePhoto() {
        let shareSheet = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        present(shareSheet, animated: true, completion: nil)
    }
}
