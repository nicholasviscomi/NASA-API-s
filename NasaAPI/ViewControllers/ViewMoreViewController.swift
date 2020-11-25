//
//  ViewMoreViewController.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 11/15/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class ViewMoreViewController: UIViewController {

    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
//        field.translatesAutoresizingMaskIntoConstraints = false
        let field = UICollectionView(frame: .zero, collectionViewLayout: layout)
        field.clipsToBounds = true
        field.backgroundColor = .clear
        field.register(ViewMoreCollectionViewCell.self, forCellWithReuseIdentifier: Constants.viewMoreCellIdentifier)
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        addViews()
        constrain()
    }
    
    fileprivate func style() {
        view.backgroundColor = .softBg
    }
    
    fileprivate func addViews() {
        view.addSubview(UIView(frame: .zero))
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    fileprivate func constrain() {
        collectionView.frame = view.bounds
    }
    
}

extension ViewMoreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // Get the number days in the past 3 months from a helper file and make those the number of cells for skelton loading
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.viewMoreCellIdentifier, for: indexPath) as! ViewMoreCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/3, height: view.frame.height/3 - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
    }
}
