//
//  BirthdayPictureViewController.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 10/3/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class BirthdayPictureViewController: UIViewController {

    fileprivate let picker: UIDatePicker = {
        let field = UIDatePicker()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.datePickerMode = .date
        field.maximumDate = Date()
        if #available(iOS 14.0, *) { field.preferredDatePickerStyle = .inline }
        field.tintColor = Colors.NasaBlue
        return field
    }()
    
    fileprivate let getPhotoButton: UIButton = {
        let field = UIButton()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = Colors.NasaBlue
        field.setTitle("Get Photo", for: .normal)
        field.setTitleColor(.secondarySystemBackground, for: .normal)
        field.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        field.layer.cornerRadius = 15
        return field
    }()
    
    fileprivate let helpLabel: UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.numberOfLines = 1
        field.textColor = Colors.textNasaBlue
        field.font = .systemFont(ofSize: 24, weight: .semibold)
        field.text = "Select a date below"
        return field
    }()
    
    var selectedDate: Date?
    
    fileprivate let APICalls = APIManager()
    fileprivate let cache = CacheManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        constrainViews()
        style()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.alpha = 1
        view.isUserInteractionEnabled = true
        navigationController?.navigationBar.isHidden = false
    }
    
    fileprivate func addViews() {
        view.addSubview(picker)
        view.addSubview(getPhotoButton)
        getPhotoButton.addTarget(self, action: #selector(getPhoto), for: .touchUpInside)
        view.addSubview(helpLabel)
    }
    
    @objc fileprivate func getPhoto() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        view.isUserInteractionEnabled = false
        view.alpha = 0.7
        
        if cache.isCached(date: formatter.string(from: picker.date)) {
            if let apod = cache.retrieveCachedAPOD(date: formatter.string(from: picker.date)) {
                DispatchQueue.main.async { [self] in
                    let vc = DetailViewController(model: apod)
                    vc.navigationController?.navigationBar.isHidden = true
                    navigationController?.pushViewController(vc, animated: true)
                    return
                }
            }
        }
        
        guard !cache.isCached(date: formatter.string(from: picker.date)) else { return }
        APICalls.getAPOD(date: formatter.string(from: picker.date)) { [self] (apod) in
            if let apod = apod {
                DispatchQueue.main.async {
                    let vc = DetailViewController(model: apod)
                    vc.navigationController?.navigationBar.isHidden = true
                    navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Couldn't Find Photo", message: "Try picking a different date", preferredStyle: .alert)
                    present(alert, animated: true, completion: nil)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                }
            }
        }
    }
    
    fileprivate func style() {
        view.backgroundColor = .secondarySystemBackground
    }
    
    fileprivate func constrainViews() {
        NSLayoutConstraint.activate([
            picker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            picker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            picker.widthAnchor.constraint(equalToConstant: view.frame.width - 50),
            picker.heightAnchor.constraint(equalToConstant: view.frame.width - 50)
        ])
        
        NSLayoutConstraint.activate([
            getPhotoButton.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: 30),
            getPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getPhotoButton.widthAnchor.constraint(equalToConstant: view.frame.width - 100),
            getPhotoButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            helpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            helpLabel.bottomAnchor.constraint(equalTo: picker.topAnchor, constant: -10)
        ])
    }

}
