//
//  ViewController.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 9/18/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    fileprivate let tableView: UITableView = {
        let field = UITableView()
        field.register(TableViewCollectionCell.self, forCellReuseIdentifier: Constants.homeCellIdentifier)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .clear
        field.separatorStyle = .none
        return field
    }()
    
    var data = [[UIImage]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        constrainViews()
        conform()
        styleUI()
        
        data = [
            [UIImage(named: "photo")!, UIImage(named: "photo2")!,UIImage(named: "photo")!, UIImage(named: "photo2")!,UIImage(named: "photo")!, UIImage(named: "photo2")!],
            [UIImage(named: "photo2")!, UIImage(named: "photo2")!,UIImage(named: "photo")!, UIImage(named: "photo2")!,UIImage(named: "photo")!, UIImage(named: "photo2")!]
        ]
    }
    
    fileprivate func addViews() {
        view.addSubview(UIView(frame: .zero))
        view.addSubview(tableView)
    }
    
    fileprivate func styleUI() {
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "NASA API's"

    }
    
    fileprivate func conform() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    fileprivate func constrainViews() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

extension HomeViewController: DetailViewDelegate {
    
    func cellWasTapped(cell: CollectionViewCell) {
        print(cell.titleLabel.center)
        addLabel()
    }
 
    func addLabel() {
        let label: UILabel = {
            let field = UILabel()
            field.translatesAutoresizingMaskIntoConstraints = false
            field.font = .systemFont(ofSize: 18, weight: .semibold)
            field.text = "    Aurora Borealis"
            field.textColor = .label
            field.backgroundColor = .tertiarySystemBackground
            return field
        }()
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            label.heightAnchor.constraint(equalToConstant: 100),
            label.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
        
        view.bringSubviewToFront(label)
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1//data[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return nil }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.homeCellIdentifier, for: indexPath) as! TableViewCollectionCell
//        cell.textLabel?.text = "Cell \(indexPath.row) Section \(indexPath.section)"
//        cell.accessoryType = .disclosureIndicator
//        cell.backgroundColor = indexPath.row % 2 == 0 ? .red : .blue
        cell.configure(with: data[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    
}

