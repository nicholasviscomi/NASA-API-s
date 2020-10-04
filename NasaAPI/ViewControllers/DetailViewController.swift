//
//  DetailViewController.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 10/2/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    let imageView: UIImageView = {
        let field = UIImageView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.contentMode = .scaleAspectFit
        field.backgroundColor = .none
        return field
    }()
    
    let model: APOD

    init(model: APOD) {
        self.model = model
        imageView.image = model.image
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
    
    fileprivate func addViews() {
        let style: UIBlurEffect.Style = traitCollection.userInterfaceStyle == .dark ? .systemUltraThinMaterialLight : .systemUltraThinMaterialDark
        view.insertSubview(blurBackground(for: view, style: style), at: 0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedBackground))
        view.addGestureRecognizer(tap)
        view.addSubview(imageView)
    }
    
    @objc func tappedBackground() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func constrainViews() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

}
