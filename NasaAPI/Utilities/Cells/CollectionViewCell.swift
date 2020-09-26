//
//  CollectionViewCell.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 9/23/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let field = UIImageView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.contentMode = .scaleAspectFit
        return field
    }()
    
    let titleLabel: UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 18, weight: .semibold)
        field.text = "    Aurora Borealis"
        field.textColor = .label
        field.backgroundColor = .tertiarySystemBackground
        return field
    }()
    
    var detailViewDelegate: DetailViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)

        configureSelf()
        setFrames()
        
    }
    
    fileprivate func setFrames() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
//            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
    }
    
    fileprivate func configureSelf() {
        self.clipsToBounds = false
        
        contentView.insertSubview(blurBackground(for: contentView, style: .extraLight), at: 0)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        let press = UILongPressGestureRecognizer(target: self, action: #selector(wasPressed))
        contentView.addGestureRecognizer(press)
    
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    @objc func wasPressed() {
        detailViewDelegate?.cellWasTapped(cell: self)
    }
    
    func configure(image: UIImage) {
        self.imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
//        guard UIApplication.shared.applicationState == .inactive else {
//            return
//        }
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
//        contentView.layer.borderWidth = 2
//        contentView.layer.borderColor = UIColor.label.cgColor
    }
}
