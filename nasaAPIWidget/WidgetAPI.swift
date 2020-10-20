//
//  WidgetAPI.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 10/15/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import SwiftUI

class WidgetAPI {
    public func getCurrentWidgetModel(completion: @escaping (WidgetModel?) -> Void) {
        let cache = CacheManager()
        if let apod = cache.retrieveCachedAPOD(date: currentDate()), let image = apod.image {
            print("got the cache from swiftUI whoop whoop")
            completion(WidgetModel(date: apod.date, title: apod.title, image: image))
            return
        } else {
            print("not found sadly")
        }
        let date = currentDate()
        let key = "W3O3phtX3OakhV5sLHZarWTYsjFUJFGcK8iKzd5o"
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=\(key)&date=\(date)"
        let url = URL(string: urlString)
        guard url != nil else {
            print("url was nil")
            completion(nil)
            return
        }
    
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, response, error) in

            if error == nil && data != nil {
                //parse json
                let decoder = JSONDecoder()
                
                do {
                    let apod = try decoder.decode(APOD.self, from: data!)
                    guard let image = apod.image else { completion(nil); return }
                    print("getting widgetmodel from API")
                    completion(WidgetModel(date: apod.date, title: apod.title, image: image))
                    return
                } catch {
                    print("error parsing")
                    completion(nil)
                    return
                }
                
                
            }
            print("error or data was nil")
            completion(nil)
            
        }
        dataTask.resume()
        
    }

}
