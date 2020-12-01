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
        layout.minimumLineSpacing = 10 //line spacing
        layout.minimumInteritemSpacing = 0 //between item spacing
        let field = UICollectionView(frame: .zero, collectionViewLayout: layout)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.clipsToBounds = true
        field.backgroundColor = .clear
        field.register(ViewMoreCollectionViewCell.self, forCellWithReuseIdentifier: Constants.viewMoreCellIdentifier)
        field.register(CollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeader.id )
        return field
    }()
    
    fileprivate let birthdaySelector: UIButton = {
        let field = UIButton()
        
        return field
    }()
    
    var data = [[APOD](), [APOD](), [APOD]()]
    var currentWeek: [APOD]
    
    init(currentWeek: [APOD]) {
        self.currentWeek = currentWeek
        data[0] = currentWeek
        data[1] = currentWeek
        data[2] = currentWeek
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        addViews()
        constrain()
    }
    
    fileprivate func style() {
        view.backgroundColor = .softBg
        navigationController?.navigationBar.tintColor = .white
    }
    
    fileprivate func addViews() {
        view.addSubview(UIView(frame: .zero))
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    fileprivate func constrain() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension ViewMoreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // Get the number days in the past 3 months from a helper file and make those the number of cells for skelton loading
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let date = Calendar.current.date(byAdding: .month, value: -section, to: Date()) {
            return numOfDaysInMonth(date: date)
        } else {
            return 0
        }//data[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeader.id, for: indexPath) as! CollectionHeader
        
        if let months = lastThreeMonths() {
            headerView.configure(month: months[indexPath.section])
        } else {
            headerView.configure(month: "        ")
        }
    
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.viewMoreCellIdentifier, for: indexPath) as! ViewMoreCollectionViewCell
        
        cell.configure(with: currentWeek[Int(UInt.random(in: 0..<7))].image!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //make the sizes be the size of the image and change on their own
        return CGSize(width: view.frame.width/3 - 20, height: view.frame.height/3 - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
    }
}
