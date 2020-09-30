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
    
    var data = [APOD]()
    var detailViewDelegate: DetailViewDelegate?
    
    func configure(with data: [APOD]) {
        self.data = data
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        contentView.clipsToBounds = false
        self.clipsToBounds = false
        
        conform()
        constrainViews()
        
        backgroundColor = .clear
        contentView.backgroundColor = .quaternaryLabel
        
    }
        
    fileprivate func constrainViews() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    fileprivate func conform() {
        collectionView.dataSource = self
        collectionView.delegate = self
//        CellLongPressViewController.reloadDelegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentView.frame.width - 130, height: contentView.frame.height - 30)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell

        cell.configure(model: data[indexPath.row])
//        cell.detailViewDelegate = HomeViewController()
        self.detailViewDelegate = HomeViewController()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else { return }
        guard let layoutAttributes = collectionView.layoutAttributesForItem(at: indexPath) else { return }
        guard let window = UIApplication.shared.windows.first else { return }
        
        let touchedLocationInWindow = collectionView.convert(cell.center, to: window)
        let cPoint = layoutAttributes.center
//        let tappedLocationInWindow = collectionView.convert(cPoint, to: window)
        print(cPoint, touchedLocationInWindow)
        
        detailViewDelegate?.cellWasTapped(cell: cell, location: touchedLocationInWindow)
    }
    
    
}

extension TableViewCollectionCell: ReloadDelegate {
    func shouldReloadCollection() {
        print("should reload")
        collectionView.reloadData()
    }
}
