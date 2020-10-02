//
//  CellLongPressViewController.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 9/26/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class CellLongPressViewController: UIViewController {

    let cell: CollectionViewCell
    
    let imageView: UIImageView = {
        let field = UIImageView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.contentMode = .scaleAspectFit
        field.backgroundColor = .none
        return field
    }()
    
    let titleLabel: UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 18, weight: .medium)
        field.textColor = .label
        field.backgroundColor = .tertiarySystemBackground
        field.textAlignment = .left
        field.numberOfLines = 1
        return field
    }()
    
    let explanation: UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 16, weight: .regular)
        field.textColor = .label
        field.backgroundColor = .clear
        field.textAlignment = .left
        field.numberOfLines = 0
        return field
    }()
    
    let dateLabel: UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 20, weight: .bold)
        field.textColor = .label
        field.backgroundColor = UIColor(cgColor: UIColor.tertiarySystemBackground.cgColor)
        field.textAlignment = .center
        return field
    }()
    
    let container = UIView()
    let location: CGPoint
    
    var imageViewWidth: NSLayoutConstraint!
    var imageViewHeight: NSLayoutConstraint!
    
    var titleWidth: NSLayoutConstraint!
    var titleHeight: NSLayoutConstraint!
    
    var cardIsOpen = false
    
//    static var reloadDelegate: ReloadDelegate?
    
    init(cell: CollectionViewCell, location: CGPoint) {
        self.cell = cell
        self.location = location
        self.imageView.image = cell.imageView.image
        self.titleLabel.text = cell.titleLabel.text
        self.explanation.text = cell.model?.explanation
        self.dateLabel.text = cell.model?.date
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        styleViews()
        constrainViews()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            UIView.animate(withDuration: 0.3) { [self] in
                container.center = view.center
                view.layoutIfNeeded()
            } completion: { [self] (_) in

                UIView.animate(withDuration: 0.8) { [self] in
                    container.frame = CGRect(x: 40, y: 125, width: view.frame.width - 80, height: view.frame.height - 250)
                    view.layoutIfNeeded()
                    
                    titleWidth.constant = container.frame.width
//                    titleHeight.constant = container.frame.height/3.5
                    
                    imageViewWidth.constant = container.frame.width
                    imageViewHeight.constant = container.frame.height - titleHeight.constant - container.frame.height/3
                    
                    view.layoutIfNeeded()
                    
                    cardIsOpen = true
                }
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1
        }
    }
    
    var blur: UIVisualEffectView!
    
    fileprivate func addViews() {
        let style: UIBlurEffect.Style = traitCollection.userInterfaceStyle == .dark ? .systemUltraThinMaterialLight : .systemUltraThinMaterialDark
        blur = blurBackground(for: self.view, style: style)
        blur.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedBackground)))
        blur.alpha = 0.6
        view.insertSubview(blur, at: 0)
        view.addSubview(container)
        container.addSubview(imageView)
        container.addSubview(titleLabel)
        container.addSubview(explanation)
        container.addSubview(dateLabel)
    }
    
    @objc func tappedBackground() {
        UIView.animate(withDuration: 0.7) { [self] in
            if cardIsOpen {
                blur.alpha = 0
                explanation.removeFromSuperview()
                
                container.frame = CGRect(origin: CGPoint(x: location.x - cell.frame.width/2, y: location.y - cell.frame.height/2), size: CGSize(width: cell.frame.width, height: cell.frame.height))
                
                imageViewHeight.constant = self.container.frame.height - 40
                imageViewWidth.constant = self.container.frame.width
                
                titleWidth.constant = self.container.frame.width
                titleHeight.constant = 40
                
                UIView.animate(withDuration: 0.45, delay: 0.25, options: .curveEaseIn) {
                    self.view.alpha = 0
                }

            }
            view.layoutIfNeeded()
        } completion: { [self] (_) in
            UIView.animate(withDuration: 0.3) {
                self.view.alpha = 0

            } completion: { (_) in
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    fileprivate func styleViews() {
        imageView.removeConstraints(imageView.constraints)
        titleLabel.removeConstraints(titleLabel.constraints)

        container.layer.cornerRadius = 15
        container.clipsToBounds = true
        container.backgroundColor = .secondarySystemBackground
    }
    
    fileprivate func constrainViews() {
        
        container.frame = CGRect(origin: CGPoint(x: location.x - cell.frame.width/2, y: location.y - cell.frame.height/2), size: CGSize(width: cell.frame.width, height: cell.frame.height))
        
        imageViewHeight = imageView.heightAnchor.constraint(equalToConstant: self.container.frame.height - self.container.frame.height/3)
        imageViewWidth = imageView.widthAnchor.constraint(equalToConstant: self.container.frame.width)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageViewWidth, imageViewHeight
        ])
        
        titleWidth = titleLabel.widthAnchor.constraint(equalToConstant: self.container.frame.width)
        titleHeight = titleLabel.heightAnchor.constraint(equalToConstant: 40)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0),
            titleHeight, titleWidth
        ])
        
        NSLayoutConstraint.activate([
            explanation.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            explanation.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 45),
            explanation.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            explanation.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.heightAnchor.constraint(equalToConstant: 30),
            dateLabel.topAnchor.constraint(equalTo: container.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0),
            dateLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
    }
}