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
    case date = "date"
    case explanation = "explanation"
    case hdurl = "hdurl"
    case media_type = "media_type"
    case title = "title"
    case url = "url"
}

class APOD: Decodable, Equatable, Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    static func == (lhs: APOD, rhs: APOD) -> Bool {
        return lhs.date == rhs.date
    }
    
    var date: String = ""
    var explanation: String = ""
    var hdurl: String = ""
    var media_type: String = ""
    var title: String = ""
    var url: String = ""
    var image: UIImage? = nil
    var videoUrl: String? = nil
    
    init(date: String, explanation: String, hdurl: String, media_type: String, title: String, url: String, image: UIImage, videoUrl: String?) {
        self.date = date
        self.explanation = explanation
        self.hdurl = hdurl
        self.media_type = media_type
        self.title = title
        self.url = url
        self.image = image
        self.videoUrl = videoUrl
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.date = try container.decode(String.self, forKey: .date)
        
        self.explanation = try container.decode(String.self, forKey: .explanation)
        
        self.title = try container.decode(String.self, forKey: .title)
        
        self.media_type = try container.decode(String.self, forKey: .media_type)
        
        if self.media_type == "image" {
            self.url = try container.decode(String.self, forKey: .url)
            self.hdurl = try container.decode(String.self, forKey: .hdurl)
            
            if let url = URL(string: url), let data = dataFrom(url: url) {
                self.image = UIImage(data: data)
            } else {
                print("no image sorry man")
            }
            
        } else if self.media_type == "video" {
            self.videoUrl = try container.decode(String.self, forKey: .url)
            let videoID = self.videoUrl?.split(separator: "/").last?.split(separator: "?").first
            let videoURL = "https://img.youtube.com/vi/\(videoID!)/hqdefault.jpg"
            print(videoURL)
            if let videoThumbnailURL = URL(string: videoURL), let data = dataFrom(url: videoThumbnailURL) {
                self.image = UIImage(data: data)
            } else {
                print("no image from YT sorry man")
            }
        }
        
    }
}
