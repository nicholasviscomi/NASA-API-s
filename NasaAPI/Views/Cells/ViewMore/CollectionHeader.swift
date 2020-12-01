//
//  CollectionHeader.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 11/29/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class CollectionHeader: UICollectionReusableView {
    static let id = "headerCellBro"
    
    fileprivate let title: UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textColor = .label
        field.backgroundColor = .accent
        field.textAlignment = .center
        field.font = .systemFont(ofSize: 30, weight: .bold)
        field.layer.cornerRadius = 20
        field.clipsToBounds = true
        return field
    }()
    func configure(month: String) {
        let new = " " + month + "   "
        title.text = new
        
        addSubview(title)
        
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
