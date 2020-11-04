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
        field.alpha = 0
        field.translatesAutoresizingMaskIntoConstraints = false
        field.contentMode = .scaleAspectFit
        field.backgroundColor = UIColor.tertiarySystemBackground.withAlphaComponent(1)
//        field.backgroundColor = .clear
        field.clipsToBounds = true
        field.isUserInteractionEnabled = true
        field.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        field.layer.cornerRadius = 25
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
    
    fileprivate let bottomView: UIView = {
        let field = UIView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.alpha = 0
        field.backgroundColor = .NasaBlue
//        field.layer.cornerRadius = 25
        return field
    }()
        
    fileprivate let explanation: UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.alpha = 0
        field.font = .systemFont(ofSize: 18, weight: .regular)
        field.textColor = .white
        field.textAlignment = .left
        field.numberOfLines = 0
//        field.backgroundColor = .secondarySystemBackground
//        field.layer.cornerRadius = 15
//        field.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        field.layer.borderWidth = 2
//        field.layer.borderColor = UIColor.black.cgColor
        return field
    }()
    
    fileprivate let topBG: UIView = {
        let field = UIView()
        field.alpha = 0
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = UIColor.black
        field.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        field.layer.cornerRadius = 25
        return field
    }()
    
    fileprivate let tommorrowBtn: UIButton = {
        let field = UIButton()
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    fileprivate let yesterdayBtn: UIButton = {
        let field = UIButton()
        field.translatesAutoresizingMaskIntoConstraints = false
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
    
    var shouldNotAniamte = false
    var previous: UIViewController!
    
    init(model: APOD, previous: UIViewController) {
        self.model = model
        self.imageView.image = model.image
        self.titleLabel.text = model.title
        self.explanation.text = model.explanation
        self.dateLabel.text = model.date
        
        self.previous = previous
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //------------------------------------------------------------------
    //MARK: View lifecycle
    //------------------------------------------------------------------
    
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
        
        if !shouldNotAniamte {
            animateIn()
        }
        shouldNotAniamte = false
        view.sendSubviewToBack(bottomView)
        
    }
    
    //------------------------------------------------------------------
    //MARK: Open photo
    //------------------------------------------------------------------
    
    @objc func didTapPhoto() {
        print("was tapped")
        shouldNotAniamte = true
        let vc = PhotoViewerViewController(model: model)
        vc.title = model.date
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
    
    //------------------------------------------------------------------
    //MARK: Check for video
    //------------------------------------------------------------------
    
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
    
    @objc func videoTapped() {
        openVideo(with: model, viewController: self)
        shouldNotAniamte = true
    }

    //------------------------------------------------------------------
    //MARK: Animations
    //------------------------------------------------------------------
    
    fileprivate func animateIn() {
        
        //MARK: MAKE THE VIEWS ANIMATE IN FROM THE TOP LIKE THE BANNERS THEY ARE
        topBG.transform = CGAffineTransform(translationX: 0, y: -topBG.frame.height - 10)
        bottomView.transform = CGAffineTransform(translationX: 0, y: bottomView.frame.height + 25)
        explanation.transform = CGAffineTransform(translationX: 0, y: bottomView.frame.height + 25)
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: { [self] in
            bottomView.transform = .identity
            explanation.transform = .identity
            topBG.transform = .identity
            
            bottomView.alpha = 1
            explanation.alpha = 1
            topBG.alpha = 1
            //            dragButton.alpha = 1
        }, completion: { [self] (done) in
            view.sendSubviewToBack(bottomView)
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -15),
                imageView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10),
                imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
            ])
            
            imageView.transform = CGAffineTransform(translationX: -view.frame.width, y: 0)
            
            UIView.animate(withDuration: 0.3, animations: {
                imageView.transform = .identity
                imageView.alpha = 1
            }) { (done) in
//                closer?.shouldClose()
            }
        })
    }
    
//    var viewTranslation = CGPoint()
//    @objc fileprivate func panBottomView(_ sender: UIPanGestureRecognizer) {
//        switch sender.state {
//        case .changed:
//            viewTranslation = sender.translation(in: view)
//            print(viewTranslation)
//
//            if viewTranslation.y < 0 {
//                break
//            }
//
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//                self.bottomView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
//            })
//
//        case .ended:
//            print("ended: \(viewTranslation.y)")
//            print("close bottom")
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//                self.bottomView.transform = .identity
//            })
//
//        default:
//            break
//        }
//    }
}

//------------------------------------------------------------------
//MARK: share sheet
//------------------------------------------------------------------

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

//------------------------------------------------------------------
//MARK: ADD and CONSTRAIN views
//------------------------------------------------------------------

extension DetailViewController {
    fileprivate func addViews() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = .NasaBlue
        
        view.addSubview(imageView)
        
        view.addSubview(topBG)
        topBG.addSubview(titleLabel)
        topBG.addSubview(dateLabel)
        
        view.addSubview(bottomView)
        bottomView.addSubview(explanation)
        
//        let drag = UIPanGestureRecognizer(target: self, action: #selector(panBottomView(_:)))
//        bottomView.addGestureRecognizer(drag)
        
        view.addSubview(exitButton)
        exitButton.addTarget(self, action: #selector(tappedBackground), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPhoto))
        tap.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tap)
    }
    
    fileprivate func constrainViews() {
        NSLayoutConstraint.activate([
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            exitButton.heightAnchor.constraint(equalToConstant: 40),
            exitButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            explanation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12.5),
            explanation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12.5),
            explanation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10),
            bottomView.topAnchor.constraint(equalTo: explanation.topAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 20),
            titleLabel.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            topBG.topAnchor.constraint(equalTo: view.topAnchor),
            topBG.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBG.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBG.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: exitButton.centerYAnchor, constant: 0)
        ])
        
//        addBG(color: .secondarySystemBackground, VCView: view, view: explanation, padding: 10)
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
    }
}
