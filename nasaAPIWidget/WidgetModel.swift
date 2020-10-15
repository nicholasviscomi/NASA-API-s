//
//  WidgetModel.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 10/14/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import SwiftUI

class WidgetModel {
    var date: String
    var title: String
    var image: UIImage
    
    init(date: String, title: String, image: UIImage) {
        self.date = date
        self.title = title
        self.image = image
    }
}

