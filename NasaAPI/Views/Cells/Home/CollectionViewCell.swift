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
        field.contentMode = .scaleAspectFill
        field.image = nil
        return field
    }()
    
    let titleLabel: UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 18, weight: .semibold)
        field.textColor = .label
        field.numberOfLines = 0
        field.backgroundColor = UIColor.tertiarySystemBackground.withAlphaComponent(1)
        field.textAlignment = .center
        field.text = "        "
        return field
    }()
    
    let dateLabel: UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 20, weight: .bold)
        field.textColor = .label
        field.backgroundColor = UIColor.tertiarySystemBackground.withAlphaComponent(1)
        field.textAlignment = .center
        field.text = "          "
        return field
    }()
    
    fileprivate let bg: UIView = {
        let field = UIView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .tertiarySystemBackground
        return field
    }()
    
    var detailViewDelegate: DetailViewDelegate?
    
    var model: APOD?
    
    fileprivate var shimmer = ShimmerLayer()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureSelf()
        setFrames()
    }
    
    func setShimmer() {
        DispatchQueue.main.async { [unowned self] in
            shimmer.removeLayerIfExists(self)
            shimmer = ShimmerLayer(for: self.contentView, cornerRadius: 12)
            self.layer.addSublayer(shimmer)
        }
    }
    
    func removeShimmer() {
        contentView.alpha = 0
        shimmer.removeFromSuperlayer()
        
        DispatchQueue.main.async { [self] in
            UIView.animate(withDuration: 0.4) {
                contentView.alpha = 1
            }
        }
    }
    
    //------------------------------------------------------------------
    //MARK: Constrain
    //------------------------------------------------------------------
    
    fileprivate func setFrames() {
        NSLayoutConstraint.activate([
//            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            bg.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -5),
            bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        ])
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bg.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            dateLabel.heightAnchor.constraint(equalToConstant: 25),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
    }
    
    //------------------------------------------------------------------
    //MARK: configureSelf
    //------------------------------------------------------------------
    
    fileprivate func configureSelf() {
        self.clipsToBounds = false
        contentView.addSubview(imageView)
        contentView.addSubview(bg)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
//        setShimmer()
    
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    let days = ["Today", "Yesterday", "2 Days Ago", "3 Days Ago", "4 Days Ago", "5 Days Ago", "6 Days Ago"]
    
    //------------------------------------------------------------------
    //MARK: Initialize
    //------------------------------------------------------------------
    
    func configure(model: APOD, indexPath: IndexPath) {
//        contentView.isUserInteractionEnabled = true
        isUserInteractionEnabled = true
        if model.media_type == "video" {
            //            print("video type found")
            //            playVideo(model: model)
            print(model.videoUrl ?? "no video url")
            self.imageView.image = model.image
        } else {
            self.imageView.image = model.image
        }
        self.titleLabel.text = "    \(model.title)"
        self.model = model
        
        self.dateLabel.text = days[indexPath.row]//model.date
    }
    
    func configureSkeletonLoading() {
//        contentView.isUserInteractionEnabled = false
        isUserInteractionEnabled = false
        print("skeleton laoding needs to be implemented")
        setShimmer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
    }
}
