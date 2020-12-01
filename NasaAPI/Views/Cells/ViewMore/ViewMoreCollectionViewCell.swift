//
//  ViewMoreCollectionViewCell.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 11/15/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class ViewMoreCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let field = UIImageView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.contentMode = .scaleAspectFill
        field.image = UIImage(systemName: "person")
        return field
    }()
    
    func configure(with image: UIImage) {
        imageView.image = image
        bringSubviewToFront(imageView)
        
        NSLayoutConstraint.activate([
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//            imageView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
//            imageView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
//            imageView.widthAnchor.constraint(equalToConstant: image.size.width/3),
//            imageView.heightAnchor.constraint(equalToConstant: image.size.height/3)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        //initialize
        backgroundColor = .tertiarySystemBackground
        layer.cornerRadius = 15
        clipsToBounds = true
        
        contentView.addSubview(imageView)
        
        
        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}
