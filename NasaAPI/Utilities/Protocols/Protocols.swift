//
//  Protocols.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 9/26/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

protocol DetailViewDelegate {
    func cellWasTapped(cell: CollectionViewCell, location: CGPoint)
}

protocol ReloadDelegate {
    func shouldReloadCollection() 
}
