//
//  GradientBackground.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 10/27/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class GradientBackground: CAGradientLayer {
    
    init(colors: [UIColor]) {
        super.init()
        self.colors = colors
        self.locations = [0.0, 1.0]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

