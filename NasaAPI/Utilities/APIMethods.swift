//
//  APIMethods.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 9/18/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class APIMethods {
    
    var dataDelegate: DataDelegate?
    
    public func getAPOD(date: String, completion: @escaping (APOD?) -> Void) {
        let key = "W3O3phtX3OakhV5sLHZarWTYsjFUJFGcK8iKzd5o"
        let date = date
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
                    completion(apod)
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
    
    public func getWeekOfAPOD(/*date: String, completion: @escaping (APOD?) -> Void*/) {
        var data = [[APOD]]()
        var count = lastWeeksDates().count
        for date in lastWeeksDates() {
            getAPOD(date: date) { [self] (apod) in
//                print("count", count)
                if apod == nil {
                    count -= 1
                }
                guard let apod = apod else {
                    return
                }

                
                if data.count == 0 {
                    data.append([apod])
                } else {
                    data[0].append(apod)
                    data[0] = data[0].sorted(by: { $0.date > $1.date })
                }
                
                if data.first?.count == count {
                    dataDelegate?.retrievedWeekOfAPOD(apods: data)
                    dataDelegate?.isFinishedLoadingAPOD()
                }
                
            }
        }
    
    }
    
    public func lastWeeksDates() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var result = [String]()
        
        let today = Date()
        let two = Date().addingTimeInterval(TimeInterval(86400 * -1))
        let three = Date().addingTimeInterval(TimeInterval(86400 * -2))
        let four = Date().addingTimeInterval(TimeInterval(86400 * -3))
        let five = Date().addingTimeInterval(TimeInterval(86400 * -4))
        let six = Date().addingTimeInterval(TimeInterval(86400 * -5))
        let seven = Date().addingTimeInterval(TimeInterval(86400 * -6))
        let days = [today,two,three,four,five,six,seven]
        
        for day in days {
            result.append(formatter.string(from: day))
        }
        return result
    }
}
