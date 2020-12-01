//
//  ViewController.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 9/18/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    fileprivate lazy var tableView: UITableView = {
        let field = UITableView()
        field.register(TableViewCollectionCell.self, forCellReuseIdentifier: Constants.homeCellIdentifier)
        field.register(HeaderTableViewCell.self, forCellReuseIdentifier: Constants.headerCellIdentifier)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .clear
        field.separatorStyle = .none
        return field
    }()
    
    var data = [[APOD]]()
    var weekCount = 7
    
    fileprivate let APICalls = APIManager()
    fileprivate let cache = CacheManager()
    
    var isFinishedLoading = false
    
    var navController: UINavigationController?
    
    var scrollDelegate: ScrollDelegate?
    
    //------------------------------------------------------------------
    //MARK: View Life Cycle
    //------------------------------------------------------------------
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        conform()
        addViews()
        constrainViews()
        styleUI()
        
//        cache.clearCache { (done) in
//            if done {
//                APICalls.getMultipleAPOD(startDate: datesFor(count: 7).last!, endDate: currentDateString())
//            }
//        }
        APICalls.getMultipleAPOD(startDate: datesFor(count: 7).last!, endDate: currentDateString())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        styleUI()
    }
    
    //------------------------------------------------------------------
    //MARK: Add & Constrain & Style
    //------------------------------------------------------------------
    
    fileprivate func addViews() {
        view.addSubview(UIView(frame: .zero))
        view.addSubview(tableView)
    }
    
    fileprivate func styleUI() {
//        view.backgroundColor = .tertiarySystemBackground
        view.backgroundColor = .softBg
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        title = "Space Flix"
        
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

//------------------------------------------------------------------
//MARK: DetailViewDelegate
//------------------------------------------------------------------

extension HomeViewController: DetailViewDelegate {
    
    func cellWasTapped(cell: CollectionViewCell, location: CGPoint, model: APOD) {
        let cellCopy = cell
        
        let vc = FloatingDetailViewController(cell: cellCopy, location: location, model: model)
        vc.title = ""
        vc.modalPresentationStyle = .overCurrentContext
        vc.navigationController?.navigationBar.isHidden = true
        
        UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: false, completion: nil)
        
    }
    
}

//------------------------------------------------------------------
//MARK: DataDelegate
//------------------------------------------------------------------

extension HomeViewController: DataDelegate {
    func retrievedWeekOfAPOD(apods: [APOD]) {
        print("append retrieved apods")
        data.append(apods)
    }
    
    func isFinishedLoadingAPOD() {
        print("is finished loading")
        DispatchQueue.main.async { [self] in
            isFinishedLoading = true
//            data[0].removeAll(where: {data[0].contains($0)})
            tableView.reloadData()
        }
    }
    
    func noDataReceived() {
        print("no data received sadly")
        
        showAlert(title: "No Photos Found", message: "There was an error with the database. We apologize for the inconvenience", view: self)
    }
}

//------------------------------------------------------------------
//MARK: TableViewDelegate/DataSource
//------------------------------------------------------------------

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1//data[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return nil }

    
    @objc func viewMore() {
        guard !data.isEmpty, data[0].count != 0 else { print("trying to access view more to early"); return }
        //instead of going to the bday vc go to the view more vc and make a separate cell that allows you to select your bday inline (shows the date picke in the cell)
//        let vc = BirthdayPictureViewController()
//        vc.title = "Birthday Picture"
//        vc.navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.pushViewController(vc, animated: true)
        let vc = ViewMoreViewController(currentWeek: data[0])
        vc.navigationController?.navigationBar.prefersLargeTitles = true
        vc.title = "Last 3 Months"
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            //header table view cell of todays photo
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.headerCellIdentifier, for: indexPath) as! HeaderTableViewCell
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.homeCellIdentifier, for: indexPath) as! TableViewCollectionCell
            print("data count = \(data.count)")
            
            if data.isEmpty {
                print("configuring empty data: Home")
                cell.configure(with: [APOD](), home: self)
            } else {
                print("configuring real data: Home")
                cell.configure(with: data[0], home: self)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            //header cell
            return (view.frame.height/5) + 30
        } else if indexPath.section == 1 {
            //week of apod
            return (view.frame.height/4) + 20
        } else {
            //default case (should never be hit)
            return (view.frame.height/4) + 20
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if type(of: cell) == HeaderTableViewCell.self {
                print("header cell tapped")
                scrollDelegate?.shouldScrollTo(indexPath: IndexPath(row: 0, section: 0))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else if section == 1 {
            return 45
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let container = UIView()
        container.backgroundColor = UIColor.softBg.withAlphaComponent(0.4)
        container.clipsToBounds = true
        
        if section == 0 {
            return topDisplayHeader(for: container)
        } else if section == 1 {
            return weekOfAPODHeader(for: container)
        }
        
        return nil
    }
    
    fileprivate func topDisplayHeader(for contaainer: UIView) -> UIView? {
        return nil
    }
    
    fileprivate func weekOfAPODHeader(for container: UIView) -> UIView? {
        let label: UILabel = {
            let field = UILabel()
            field.translatesAutoresizingMaskIntoConstraints = false
            field.font = .systemFont(ofSize: 28, weight: .bold)
//            field.textColor = .label
            field.textColor = .white
            field.backgroundColor = .clear
            field.textAlignment = .center
            field.numberOfLines = 0
            return field
        }()
        
        let button: UIButton = {
            let field = UIButton()
            
            field.translatesAutoresizingMaskIntoConstraints = false
            field.tintColor = .link
            field.setTitleColor(.white, for: .normal)
            field.setTitle("View More", for: .normal)
            field.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        guard UIApplication.shared.applicationState == .inactive else { return }
        
        print("changing trait collection broooooooo")
        if var textAttributes = navigationController?.navigationBar.titleTextAttributes {
            textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.white
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        }
        
    }
}

