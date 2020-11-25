//
//  HeaderTableViewCell.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 11/3/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    fileprivate let cache = CacheManager()
    fileprivate let api = APIManager()
    
    fileprivate let contentImageView: UIImageView = {
        let field = UIImageView()
//        field.translatesAutoresizingMaskIntoConstraints = false
        field.contentMode = .scaleAspectFill
        field.image = nil
        return field
    }()
    
    fileprivate let titleLabel: UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 20, weight: .bold)
        field.textColor = .label
        field.numberOfLines = 0
        field.backgroundColor = UIColor.tertiarySystemBackground.withAlphaComponent(0.45)
        field.textAlignment = .center
        field.text = "              \n             "
        field.layer.cornerRadius = 15
        field.clipsToBounds = true
        return field
    }()
    
    fileprivate let dateLabel: UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 20, weight: .semibold)
        field.textColor = .secondarySystemBackground
        field.backgroundColor = UIColor.label.withAlphaComponent(0.45)
        field.textAlignment = .center
        field.text = "      "
        field.layer.cornerRadius = 15
        field.clipsToBounds = true
        return field
    }()
    
    fileprivate let bgContainer: UIView = {
        let field = UIView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = UIColor.tertiarySystemBackground.withAlphaComponent(0.6)
        field.layer.cornerRadius = 15
        field.clipsToBounds = true
        return field
    }()
    
//    var apod: APOD!
    
    fileprivate var shimmer = ShimmerLayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        DispatchQueue.main.async { [unowned self] in
            shimmer.removeLayerIfExists(self)
            shimmer = ShimmerLayer(for: contentView, cornerRadius: 12)
            self.layer.addSublayer(shimmer)
        }
        
        contentView.clipsToBounds = true
        contentView.backgroundColor = .tertiarySystemBackground
        
        if let apod = cache.retrieveCachedAPOD(date: currentDateString()) {
//            self.apod = apod
            
            DispatchQueue.main.async { [self] in
                contentImageView.image = apod.image
                titleLabel.text = " \(apod.title) "
                dateLabel.text = "Today"
                
                addViews()
                constrainViews()
                
                shimmer.removeAnimation()
                shimmer.removeFromSuperlayer()
            }
            
        } else {
            api.getAPOD(date: currentDateString()) { [self] (apod) in
                guard let apod = apod else { return }
//                self.apod = apod
                
                DispatchQueue.main.async {
                    contentImageView.image = apod.image
                    titleLabel.text = " \(apod.title) "
                    dateLabel.text = "Today"
                    
                    addViews()
                    constrainViews()
                    
                    shimmer.removeAnimation()
                    shimmer.removeFromSuperlayer()
                }
            }
        }
        
    }
    
    fileprivate func addViews() {
        contentView.addSubview(contentImageView)
        contentView.addSubview(bgContainer)
        bgContainer.addSubview(titleLabel)
//        bgContainer.addSubview(dateLabel)
    }
    
    fileprivate func constrainViews() {
        contentImageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height-70)
        
        NSLayoutConstraint.activate([
            bgContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            bgContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bgContainer.widthAnchor.constraint(equalToConstant: contentView.frame.width - 70),
            bgContainer.heightAnchor.constraint(equalToConstant: contentView.frame.height - 110)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: bgContainer.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: bgContainer.topAnchor, constant: 15),
            titleLabel.bottomAnchor.constraint(equalTo: bgContainer.bottomAnchor, constant: -15),
            titleLabel.trailingAnchor.constraint(equalTo: bgContainer.trailingAnchor, constant: -15)
        ])
        
//        NSLayoutConstraint.activate([
//            dateLabel.topAnchor.constraint(equalTo: bgContainer.topAnchor, constant: 15),
//            dateLabel.bottomAnchor.constraint(equalTo: bgContainer.bottomAnchor, constant: -15),
//            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
//            dateLabel.trailingAnchor.constraint(equalTo: bgContainer.trailingAnchor, constant: -15)
//        ])
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
