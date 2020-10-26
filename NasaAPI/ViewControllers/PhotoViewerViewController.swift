//
//  PhotoViewerViewController.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 10/10/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class PhotoViewerViewController: UIViewController {

    fileprivate let imageView: UIImageView = {
        let field = UIImageView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.contentMode = .scaleAspectFit
        field.backgroundColor = .clear
        field.clipsToBounds = true
//        field.enableZoom()
        return field
    }()
    
    fileprivate let scrollView: UIScrollView = {
        let field = UIScrollView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.minimumZoomScale = 1.0
        field.maximumZoomScale = 5.0
        field.isScrollEnabled = true
        return field
    }()
    
    fileprivate lazy var share: UIButton = {
        let field = UIButton()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        field.tintColor = .link
        field.backgroundColor = .clear
        field.layer.cornerRadius = 15
        return field
    }()
    
    fileprivate lazy var download: UIButton = {
        let field = UIButton()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.setBackgroundImage(UIImage(named: "downloadImage"), for: .normal)
        field.tintColor = .link
        field.backgroundColor = .clear
        field.layer.cornerRadius = 15
        return field
    }()
    
    fileprivate lazy var bg: UIView = {
        let field = UIView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 35
        return field
    }()
        
    let model: APOD
    var image: UIImage
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
    
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
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(sharePhoto))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(close))
    }
    
    @objc fileprivate func close() {
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
        return [image, "\(model.title): \(model.date)"]
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return model.title
    }
    
    @objc fileprivate func sharePhoto() {
        let shareSheet = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        present(shareSheet, animated: true, completion: nil)
    }
    
    @objc fileprivate func downloadImage() {
        print("download image bruhhhhhhhhhhh")
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc fileprivate func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
        } else {
            
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
        }
    }
}

extension PhotoViewerViewController {
    fileprivate func configure() {
        let style: UIBlurEffect.Style = traitCollection.userInterfaceStyle == .dark ? .systemUltraThinMaterialLight : .systemUltraThinMaterialDark
        let blur = blurBackground(for: view, style: style)
        blur.alpha = 1
        view.insertSubview(blur, at: 0)
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        view.addSubview(bg)
        
        view.addSubview(download)
        download.addTarget(self, action: #selector(downloadImage), for: .touchUpInside)
        
        view.addSubview(share)
        share.addTarget(self, action: #selector(sharePhoto), for: .touchUpInside)
        
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
        
        NSLayoutConstraint.activate([
            download.heightAnchor.constraint(equalToConstant: 60),
            download.widthAnchor.constraint(equalToConstant: 60),
            download.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -80),
            download.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            share.heightAnchor.constraint(equalToConstant: 60),
            share.widthAnchor.constraint(equalToConstant: 60),
            share.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 80),
            share.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            bg.topAnchor.constraint(equalTo: share.topAnchor, constant: -7.5),
            bg.bottomAnchor.constraint(equalTo: share.bottomAnchor, constant: 7.5),
            bg.leadingAnchor.constraint(equalTo: download.leadingAnchor, constant: -20),
            bg.trailingAnchor.constraint(equalTo: share.trailingAnchor, constant: 20)
        ])
    }
}
