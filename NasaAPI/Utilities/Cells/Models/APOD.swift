//
//  APOD.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 9/29/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

//MARK: actually make this codable and finish api calls and the dtail view controller

enum CodingKeys: String, CodingKey {
    case copyright = "copyright"
    case explanation = "explanation"
    case hdurl = "hdurl"
    case media_type = "media_type"
    case title = "title"
    case url = "url"
}

class APOD: Decodable {
    var copyright: String?
    var explanation: String = ""
    var hdurl: String = ""
    var media_type: String = ""
    var title: String = ""
    var url: String = ""
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.copyright = try container.decode(String.self, forKey: .copyright)
    
        self.explanation = try container.decode(String.self, forKey: .explanation)
        
        self.hdurl = try container.decode(String.self, forKey: .hdurl)
        
        self.media_type = try container.decode(String.self, forKey: .media_type)
        
        self.title = try container.decode(String.self, forKey: .title)
        
        self.url = try container.decode(String.self, forKey: .url)
    }
}
