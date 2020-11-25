//
//  TableViewCollectionCell.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 9/23/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class TableViewCollectionCell: UITableViewCell {
    
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
//        field.isPagingEnabled = true
        return field
    }()

    var data = [APOD]()
    
    var detailViewDelegate: DetailViewDelegate?
    
    var home: HomeViewController?
    
    var indexOfCellBeforeDragging = 0
    
    func configure(with data: [APOD], home: HomeViewController) {
        print("Configuring",data.count, self.data.count)
        self.home = home
        self.data = data
        collectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: true)
        }

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.addSubview(backgroundImage)
        contentView.addSubview(collectionView)
        contentView.clipsToBounds = false
        self.clipsToBounds = false
        
        conform()
        constrainViews()
        
        backgroundColor = .cellBg
        contentView.backgroundColor = .cellBg
        
//        let gradient = GradientBackground(colors: [.white, .blue])
//        gradient.frame = contentView.bounds
//        contentView.layer.insertSublayer(gradient, at: 0)

    }
        
    //------------------------------------------------------------------
    //MARK: Constrain
    //------------------------------------------------------------------
    
    fileprivate func constrainViews() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
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
    
}

//------------------------------------------------------------------
//MARK: Collection View
//------------------------------------------------------------------

extension TableViewCollectionCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentView.frame.width - 130, height: contentView.frame.height - 30)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !data.isEmpty {
            return data.count
        } else {
            return 7 //data.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        if data.count == 0 {
            print("configure skeleton loading")
            cell.configureSkeletonLoading()
        } else {
            cell.configure(model: data[indexPath.row], indexPath: indexPath)
            cell.removeShimmer()
        }
        
//        print("\(data[indexPath.row].title): type = \(data[indexPath.row].media_type)")
        
        guard let home = home else { return UICollectionViewCell() }
        self.detailViewDelegate = home
        home.scrollDelegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else { return }
//        guard let layoutAttributes = collectionView.layoutAttributesForItem(at: indexPath) else { return }
        guard let window = UIApplication.shared.windows.first else { return }
        
        let touchedLocationInWindow = collectionView.convert(cell.center, to: window)
//        let cPoint = layoutAttributes.center
//        let tappedLocationInWindow = collectionView.convert(cPoint, to: window)
//        print(cPoint, touchedLocationInWindow)
        
        if cell.imageView.image != nil {
            detailViewDelegate?.cellWasTapped(cell: cell, location: touchedLocationInWindow, model: data[indexPath.row])
        }
    }
}

extension TableViewCollectionCell: ScrollDelegate {
    func shouldScrollTo(indexPath: IndexPath) {
        print("should scroll to new index")
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            collectionView(collectionView, didSelectItemAt: indexPath)
        }
    }
}

extension TableViewCollectionCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset)
    }
}
