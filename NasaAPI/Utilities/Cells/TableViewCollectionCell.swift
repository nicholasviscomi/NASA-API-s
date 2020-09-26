//
//  TableViewCollectionCell.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 9/23/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class TableViewCollectionCell: UITableViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        let field = UICollectionView(frame: .zero, collectionViewLayout: layout)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        field.backgroundColor = .clear
        field.showsHorizontalScrollIndicator = false
        field.clipsToBounds = false
        return field
    }()
    
    var data = [UIImage]()
    
    func configure(with data: [UIImage]) {
        self.data = data
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        contentView.clipsToBounds = false
        self.clipsToBounds = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        backgroundColor = .quaternarySystemFill
        contentView.backgroundColor = .quaternarySystemFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width - 100, height: self.collectionView.frame.height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell

        cell.configure(image: data[indexPath.row])
        cell.detailViewDelegate = HomeViewController()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
}
