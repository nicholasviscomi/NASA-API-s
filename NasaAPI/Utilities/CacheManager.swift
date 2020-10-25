//
//  CacheManager.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 10/16/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

struct keys {
    static let firstDate = "firstDate"
}

final class CacheManager {
    let defaults = UserDefaults.standard
    
    public func checkForClear(completion: @escaping (Bool) -> Void) {
        print(currentDate().addingTimeInterval(TimeInterval(86400 * -7)))
        
        if let firstOpened = defaults.string(forKey: keys.firstDate) {
            let weekAgoDate = string(from: currentDate().addingTimeInterval(TimeInterval(86400 * -1)))
            
            if weekAgoDate == firstOpened {
                print("should clear cache. It has been 1 week since openeing the app")
                clearCache { (_) in }
                defaults.setValue(currentDateString(), forKey: keys.firstDate)
            } else {
                print("not a week ago yet")
                completion(true)
            }
            completion(true)
            return
        } else {
            print("set the date of first time the app was opened")
            defaults.setValue(currentDateString(), forKey: keys.firstDate)
            completion(true)
            return
        }
    }
    
    ///cache an image
    public func cache(apod: APOD, date: String) {
        guard let image = apod.image, let data = imageData(from: image) else { return }
        defaults.set(apod.date, forKey: date + Extensions.date.rawValue)
        defaults.set(apod.explanation, forKey: date + Extensions.explanation.rawValue)
        defaults.set(apod.hdurl, forKey: date + Extensions.hdurl.rawValue)
        defaults.set(apod.media_type, forKey: date + Extensions.media_type.rawValue)
        defaults.set(apod.title, forKey: date + Extensions.title.rawValue)
        defaults.set(apod.url, forKey: date + Extensions.url.rawValue)
        defaults.set(data, forKey: date + Extensions.image.rawValue)
        defaults.set(apod.videoUrl, forKey: date + Extensions.videoUrl.rawValue)
    }

    ///check for cached item
    public func isCached(date: String) -> Bool {
        let result = defaults.string(forKey: date + Extensions.title.rawValue)
        return result != nil
    }
    
    public func retrieveCachedAPOD(date: String) -> APOD? {
        
        guard let imageDate = defaults.string(forKey: date + Extensions.date.rawValue),
              let explanation = defaults.string(forKey: date + Extensions.explanation.rawValue),
              let hdurl = defaults.string(forKey: date + Extensions.hdurl.rawValue),
              let media_type = defaults.string(forKey: date + Extensions.media_type.rawValue),
              let title = defaults.string(forKey: date + Extensions.title.rawValue),
              let url = defaults.string(forKey: date + Extensions.url.rawValue),
              let data = defaults.data(forKey: date + Extensions.image.rawValue) else { return nil }
        
        
        if media_type == "video" {
            guard let videoUrl = defaults.string(forKey: date + Extensions.date.rawValue), let image = imageFrom(data: data) else { return nil }
            return APOD(date: imageDate, explanation: explanation, hdurl: hdurl, media_type: media_type, title: title, url: url, image: image, videoUrl: videoUrl)
        }
        return (imageFrom(data: data) != nil) ? APOD(date: imageDate, explanation: explanation, hdurl: hdurl, media_type: media_type, title: title, url: url, image: imageFrom(data: data)!, videoUrl: nil) : nil
    }
    
    public func clearCache(completion: (Bool) -> Void) {
        guard let domain = Bundle.main.bundleIdentifier else { completion(false); return }
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
        print("clearing cache")
        completion(true)
    }
    
    
}

enum Extensions: String, CaseIterable {
    case date = "_date"
    case explanation = "_explanation"
    case hdurl = "_hdurl"
    case media_type = "_media_type"
    case title = "_title"
    case url = "_url"
    case image = "_image"
    case videoUrl = "_videoUrl"
}
