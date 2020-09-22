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
        field.register(UITableViewCell.self, forCellReuseIdentifier: Constants.homeCellIdentifier)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .clear
        field.separatorStyle = .none
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        constrainViews()
        conform()
        styleUI()
        
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

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.homeCellIdentifier, for: indexPath)
        cell.textLabel?.text = "Cell \(indexPath.row) Section \(indexPath.section)"
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = indexPath.row % 2 == 0 ? .red : .blue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}

