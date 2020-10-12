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
        field.allowsSelection = false
        return field
    }()
    
    var data = [[APOD]]()
    var weekCount = 7
    let APICalls = APIMethods()
    
    var isFinishedLoading = false
    
    var navController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        constrainViews()
        conform()
        styleUI()

        APICalls.getWeekOfAPOD()
        
//        for date in APICalls.lastWeeksDates() {
//            APICalls.getAPOD(date: date) { [self] (apod) in
//                guard let apod = apod else {
//                    return
//                }
//
//                print(apod.media_type)
//
//                if data.count == 0 {
//                    data.append([apod])
//                } else {
//                    data[0].append(apod)
//                }
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
////                    data.append(row)
//                    if data.count != 0 {
////                        let formatter = DateFormatter()
////                        data[0].forEach { (apod) in
////
////                            formatter.dateFormat = "yyyy-MM-dd"
////                            let date = formatter.date(from: apod.date)
////                            print(date as Any)
////                        }
//                        data[0] = data[0].sorted(by: { $0.date > $1.date })
//                        weekCount = data[0].count
//                    }
//                    tableView.reloadData()
//                }
//            }
//        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    fileprivate func addViews() {
        view.addSubview(UIView(frame: .zero))
        view.addSubview(tableView)
    }
    
    fileprivate func styleUI() {
        view.backgroundColor = .tertiarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "NASA API's"
        
        navController = navigationController
    }
    
    fileprivate func conform() {
        tableView.delegate = self
        tableView.dataSource = self
        APICalls.dataDelegate = self
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
    
    func cellWasTapped(cell: CollectionViewCell, location: CGPoint, model: APOD) {
        let cellCopy = cell
        
        let vc = CellLongPressViewController(cell: cellCopy, location: location, model: model)
        vc.title = ""
        vc.modalPresentationStyle = .overCurrentContext
        vc.navigationController?.navigationBar.isHidden = true
        
        UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: false, completion: nil)
        
    }
    
}

extension HomeViewController: DataDelegate {
    func retrievedWeekOfAPOD(apods: [[APOD]]) {
        data = apods
    }
    
    func isFinishedLoadingAPOD() {
        print("is finished loading")
        DispatchQueue.main.async { [self] in
            isFinishedLoading = true
            tableView.reloadData()
        }
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
        let container = UIView()
        container.backgroundColor = .clear
        container.clipsToBounds = true
        
        let label: UILabel = {
            let field = UILabel()
            field.translatesAutoresizingMaskIntoConstraints = false
            field.font = .systemFont(ofSize: 30, weight: .bold)
            field.textColor = .label
            field.backgroundColor = .clear
            field.textAlignment = .center
            field.numberOfLines = 0
            return field
        }()
        
        let button: UIButton = {
            let field = UIButton()
            field.translatesAutoresizingMaskIntoConstraints = false
            field.tintColor = .link
            field.setTitleColor(UIColor(red: 0.34, green: 0.41, blue: 0.54, alpha: 1.00), for: .normal)
            field.setTitle("View More", for: .normal)
            field.titleLabel?.font = .systemFont(ofSize: 22, weight: .semibold)
            field.titleLabel?.textAlignment = .left
//            field.setImage(UIImage(systemName: "chevron.right.circle.fill"), for: .normal)
            return field
        }()
        
        container.addSubview(label)
        container.addSubview(button)
        
        button.addTarget(self, action: #selector(viewMore), for: .touchUpInside)
        
        label.text = "Last Week"
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            button.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        return container
    }
    
    @objc func viewMore() {
        let vc = BirthdayPictureViewController()
        vc.title = "Birthday Picture"
        vc.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.homeCellIdentifier, for: indexPath) as! TableViewCollectionCell
        
        cell.configure(with: data[indexPath.section])
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.frame.height/4) + 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

