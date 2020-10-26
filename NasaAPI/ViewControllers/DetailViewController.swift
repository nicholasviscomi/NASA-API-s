//
//  DetailViewController.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 10/2/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

// UIColor(red: 0.34, green: 0.41, blue: 0.54, alpha: 1.00)

class DetailViewController: UIViewController {
    
    fileprivate let imageView: UIImageView = {
        let field = UIImageView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.contentMode = .scaleAspectFit
        field.backgroundColor = UIColor.quaternaryLabel.withAlphaComponent(0.2)
        field.clipsToBounds = true
        field.isUserInteractionEnabled = true
        field.alpha = 0
        return field
    }()
    
    fileprivate let titleLabel: UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 28, weight: .bold)
        field.textColor = .white
        field.backgroundColor = .clear
        field.textAlignment = .center
        field.numberOfLines = 0
//        field.layer.borderWidth = 2
//        field.layer.borderColor = UIColor.black.cgColor
        return field
    }()
    
    fileprivate let dateLabel: UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 24, weight: .semibold)
        field.textColor = .white
        field.backgroundColor = .clear
        field.textAlignment = .center
        field.numberOfLines = 0
//        field.layer.borderWidth = 2
//        field.layer.borderColor = UIColor.black.cgColor
        return field
    }()
    
    fileprivate let explanation: UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 18, weight: .regular)
        field.textColor = .white
        field.textAlignment = .left
        field.numberOfLines = 0
//        field.layer.borderWidth = 2
//        field.layer.borderColor = UIColor.black.cgColor
        return field
    }()

    fileprivate let exitButton: UIButton = {
        let field = UIButton(type: .close)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.titleLabel?.textColor = .link
        field.backgroundColor = .systemBackground
//        field.setTitle("Close", for: .normal)
        field.layer.cornerRadius = 20
        return field
    }()
    
    fileprivate let playButton: UIButton = {
        let field = UIButton()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        field.tintColor = .NasaBlue
        field.backgroundColor = .clear
        return field
    }()
    
    fileprivate let bgView: UIView = {
        let field = UIView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .systemBackground
        field.layer.cornerRadius = 25
        return field
    }()
    
//    let sidebar: UIView = {
//        let field = UIView()
//        field.translatesAutoresizingMaskIntoConstraints = false
//        field.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.6)
//        field.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
//        return field
//    }()
//
//    lazy var share: UIButton = {
//        let field = UIButton()
//        field.translatesAutoresizingMaskIntoConstraints = false
//        field.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
//        field.tintColor = .link
//        field.backgroundColor = .clear
//        field.layer.cornerRadius = 15
//        return field
//    }()
//
//    lazy var download: UIButton = {
//        let field = UIButton()
//        field.translatesAutoresizingMaskIntoConstraints = false
//        field.setBackgroundImage(UIImage(named: "downlaodIcon"), for: .normal)
//        field.tintColor = .link
//        field.backgroundColor = .clear
//        field.layer.cornerRadius = 15
//        return field
//    }()
    
    let model: APOD

    var closer: CloserDelegate?
    
    init(model: APOD) {
        self.model = model
        self.imageView.image = model.image
        self.titleLabel.text = model.title
        self.explanation.text = model.explanation
        self.dateLabel.text = model.date
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        constrainViews()
        closer?.shouldClose()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addViews()
        checkForVideo()
        constrainViews()
        
        UIView.animate(withDuration: 0.3) {
            self.imageView.alpha = 1
        }

    }
    
    @objc func didTapPhoto() {
        print("was tapped")
        let vc = PhotoViewerViewController(model: model)
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: true, completion: nil)
    }
    
    @objc func tappedBackground() {
        if navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        }
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func checkForVideo() {
        if model.media_type == "video" {
            view.addSubview(bgView)
            view.addSubview(playButton)
            
            NSLayoutConstraint.activate([
                playButton.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
                playButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
                playButton.widthAnchor.constraint(equalToConstant: 30),
                playButton.heightAnchor.constraint(equalToConstant: 30)
            ])
            
            NSLayoutConstraint.activate([
                bgView.centerXAnchor.constraint(equalTo: playButton.centerXAnchor),
                bgView.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
                bgView.widthAnchor.constraint(equalToConstant: 50),
                bgView.heightAnchor.constraint(equalToConstant: 50)
            ])
            
            playButton.addTarget(self, action: #selector(videoTapped), for: .touchUpInside)
        }
    }
    
    @objc func videoTapped() { openVideo(with: model, viewController: self) }

    fileprivate func addViews() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = Colors.NasaBlue
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        view.addSubview(explanation)
        
//        view.addSubview(sidebar)
//
//        sidebar.addSubview(share)
//        share.addTarget(self, action: #selector(sharePhoto), for: .touchUpInside)
//
//        sidebar.addSubview(download)
//        download.addTarget(self, action: #selector(downloadPhoto), for: .touchUpInside)
        
        view.addSubview(exitButton)
        exitButton.addTarget(self, action: #selector(tappedBackground), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPhoto))
        tap.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tap)
    }
}

extension DetailViewController: UIActivityItemSource {
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return UIImage(named: "Image")!
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        
        if model.image != nil {
            return [model.image!, "\(model.title): \(model.date)"]
            
        } else { return nil }
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return model.title
    }
    
    @objc fileprivate func sharePhoto() {
        let shareSheet = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        present(shareSheet, animated: true, completion: nil)
    }
    
    @objc fileprivate func downloadPhoto() {
        print("download the photo bruhhhhhhhhhhh")
    }
}

extension DetailViewController {
    fileprivate func constrainViews() {
        NSLayoutConstraint.activate([
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            exitButton.heightAnchor.constraint(equalToConstant: 40),
            exitButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            explanation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            explanation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            explanation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 20),
            titleLabel.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: exitButton.centerYAnchor, constant: 0)
        ])
        
//        NSLayoutConstraint.activate([
//            sidebar.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
//            sidebar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
////            sidebar.heightAnchor.constraint(equalToConstant: imageView.frame.height - 30),
//            sidebar.widthAnchor.constraint(equalToConstant: 50)
//        ])
//
//        NSLayoutConstraint.activate([
//            share.widthAnchor.constraint(equalToConstant: 40),
//            share.heightAnchor.constraint(equalToConstant: 40),
//            share.centerXAnchor.constraint(equalTo: sidebar.centerXAnchor),
//            share.centerYAnchor.constraint(equalTo: sidebar.centerYAnchor, constant: -30)
//        ])
//
//        NSLayoutConstraint.activate([
//            download.widthAnchor.constraint(equalToConstant: 40),
//            download.heightAnchor.constraint(equalToConstant: 40),
//            download.centerXAnchor.constraint(equalTo: sidebar.centerXAnchor),
//            download.centerYAnchor.constraint(equalTo: sidebar.centerYAnchor, constant: 30)
//        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: explanation.topAnchor, constant: -10),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }
}
