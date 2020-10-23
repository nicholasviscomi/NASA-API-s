//
//  Protocols.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 9/26/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

protocol DetailViewDelegate {
    ///sends the selected cell to the long press controller
    func cellWasTapped(cell: CollectionViewCell, location: CGPoint, model: APOD)
}

protocol DataDelegate {
    func isFinishedLoadingAPOD()
    ///notifies home vc that is got all the data it needs for APOD
    func retrievedWeekOfAPOD(apods: [[APOD]])
    
    func noDataReceived()
}

protocol CloserDelegate {
    func shouldClose()
}
