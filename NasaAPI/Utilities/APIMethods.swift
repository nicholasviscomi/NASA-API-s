//
//  APIMethods.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 9/18/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class APIMethods {
    public func getAPOD(date: String, completion: @escaping (APOD?) -> Void) {
        let key = "W3O3phtX3OakhV5sLHZarWTYsjFUJFGcK8iKzd5o"
        let date = date
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=\(key)&date=\(date)"
        let url = URL(string: urlString)
        guard url != nil else { completion(nil); return }
        
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, response, error) in

            if error == nil && data != nil {
                //parse json
                let decoder = JSONDecoder()
                
                do {
                    let apod = try decoder.decode(APOD.self, from: data!)
                    completion(apod)
                } catch {
                    completion(nil)
                }
                
                
            }
            completion(nil)
            
        }
        dataTask.resume()
    }
}
