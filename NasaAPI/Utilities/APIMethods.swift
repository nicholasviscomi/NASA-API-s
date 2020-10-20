//
//  APIMethods.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 9/18/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

final class APIMethods {
    
    var dataDelegate: DataDelegate?
    let cache = CacheManager()
    
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
        let dataTask = session.dataTask(with: url!) { [self] (data, response, error) in

            if error == nil && data != nil {
                //parse json
                let decoder = JSONDecoder()
                
                do {
                    let apod = try decoder.decode(APOD.self, from: data!)
                    
                    let isCached = cache.isCached(date: apod.date)
                    print("is cached = \(isCached)")
                    if !isCached {
                        cache.cache(apod: apod, date: apod.date)
                        print("caching \(apod.date)")
                    }
                    
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
    
    public func getMultipleAPOD(/*date: String, completion: @escaping (APOD?) -> Void*/) {
        var data = [[APOD]]()
        var count = datesFor(count: numOfDaysInCurrentMonth()).count
        for date in datesFor(count: numOfDaysInCurrentMonth()) {
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
                    if !(data[0].contains(apod)) {
                        data[0].append(apod)
                    }
                }
                
                if data.first?.count == count {
                    data[0] = data[0].sorted(by: { $0.date > $1.date })
                    dataDelegate?.retrievedWeekOfAPOD(apods: data)
                    dataDelegate?.isFinishedLoadingAPOD()
                }
                
            }
        }
    
    }
    
    public func testCall() {
        let key = "W3O3phtX3OakhV5sLHZarWTYsjFUJFGcK8iKzd5o"
//        let date = "2020-10-11"
        let start = datesFor(count: 7).last!
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=\(key)&start_date=\(start)&end_date=\(currentDate())"
        let url = URL(string: urlString)
        guard url != nil else {
            print("url was nil")
            return
        }
        
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, response, error) in

            if error == nil && data != nil {
                //parse json
                let decoder = JSONDecoder()
                
                do {
                    let apods = try decoder.decode([APOD].self, from: data!)
                    for apod in apods {
                        print("here is the title: \(apod.title)")
                    }
//                    let isCached = cache.isCached(date: apod.date)
//                    print("is cached = \(isCached)")
//                    if !isCached {
//                        cache.cache(apod: apod, date: apod.date)
//                        print("caching \(apod.date)")
//                    }
                    
                    return
                } catch {
                    print("error parsing")
                    return
                }
                
                
            }
            print("error or data was nil")
            
        }
        dataTask.resume()
    }
    
    public func datesFor(count: Int) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var result = [String]()
        
        for i in 0..<count {
            let date = Date().addingTimeInterval(TimeInterval(86400 * (i * -1)))
            result.append(formatter.string(from: date))
        }
//        let today = Date()
//        let two = Date().addingTimeInterval(TimeInterval(86400 * -1))
//        let three = Date().addingTimeInterval(TimeInterval(86400 * -2))
//        let four = Date().addingTimeInterval(TimeInterval(86400 * -3))
//        let five = Date().addingTimeInterval(TimeInterval(86400 * -4))
//        let six = Date().addingTimeInterval(TimeInterval(86400 * -5))
//        let seven = Date().addingTimeInterval(TimeInterval(86400 * -6))
//        let days = [today,two,three,four,five,six,seven]
//
//        for day in days {
//            result.append(formatter.string(from: day))
//        }
        return result
    }
}
