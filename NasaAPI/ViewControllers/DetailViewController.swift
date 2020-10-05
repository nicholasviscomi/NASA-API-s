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
    
    let imageView: UIImageView = {
        let field = UIImageView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.contentMode = .scaleAspectFit
        field.backgroundColor = .black
        return field
    }()
    
    let titleLabel: UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 28, weight: .bold)
        field.textColor = .white
        field.backgroundColor = .clear
        field.textAlignment = .center
        field.numberOfLines = 0
        field.text = "Please Work"
        return field
    }()
    
    let explanation: UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 18, weight: .regular)
        field.textColor = .white
        field.textAlignment = .left
        field.numberOfLines = 0
        return field
    }()

    let exitButton: UIButton = {
        let field = UIButton(type: .close)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tintColor = .white
        field.backgroundColor = .black
        field.layer.cornerRadius = 25
        return field
    }()
    
    let model: APOD

    init(model: APOD) {
        self.model = model
        self.imageView.image = model.image
        self.titleLabel.text = model.title
        self.explanation.text = model.explanation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        constrainViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    fileprivate func addViews() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(red: 0.34, green: 0.41, blue: 0.54, alpha: 1.00)
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(explanation)
        
//        if navigationController == nil {
        view.addSubview(exitButton)
        exitButton.addTarget(self, action: #selector(tappedBackground), for: .touchUpInside)
//        }
    }
    
    @objc func tappedBackground() {
//        self.dismiss(animated: true, completion: nil)
        if navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        }
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func constrainViews() {
//        if navigationController == nil {
        NSLayoutConstraint.activate([
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            exitButton.heightAnchor.constraint(equalToConstant: 50),
            exitButton.widthAnchor.constraint(equalToConstant: 50)
        ])
//        }
        
        NSLayoutConstraint.activate([
            explanation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            explanation.widthAnchor.constraint(equalToConstant: view.frame.width - 20),
            explanation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 20),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60)
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            imageView.widthAnchor.constraint(equalToConstant: view.frame.width - 20),
            imageView.bottomAnchor.constraint(equalTo: explanation.topAnchor, constant: -10)
//            imageView.heightAnchor.constraint(equalToConstant: view.frame.height - explanation.frame.height)
        ])
//        imageView.frame = view.bounds

        
    }

}
