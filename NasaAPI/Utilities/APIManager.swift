//
//  APIMethods.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 9/18/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

final class APIManager {
    
    var dataDelegate: DataDelegate?
    let cache = CacheManager()
    let dispatch = DispatchGroup()
    
    let key = "W3O3phtX3OakhV5sLHZarWTYsjFUJFGcK8iKzd5o"
    
    //------------------------------------------------------------------
    //MARK: get single APOD
    //------------------------------------------------------------------
    
    public func getAPOD(date: String, completion: @escaping (APOD?) -> Void) {
        
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
                    if !isCached {
//                        cache.cache(apod: apod, date: apod.date)
//                        print("caching \(apod.date)")
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
    
    //------------------------------------------------------------------
    //make start and end date and count parameters; when checking cache for apods if you find one remove it from array of dates and then send those dates in this funciton below
    //MARK: get multiple apod
    //------------------------------------------------------------------
    
    public func getMultipleAPOD() {
        var start = datesFor(count: 7).last!
        var end = currentDateString()
        var dates = datesFor(count: 7)
        
        var apods = [APOD]()
        var cachedApods =  [APOD]()
        
        dispatch.enter()
        cache.checkForClear { [self] (done) in
            for date in dates {
                if cache.isCached(date: date) {
                    if let apod = cache.retrieveCachedAPOD(date: date) {
                        cachedApods.append(apod)
                        //remove the date that was found
                        dates = dates.filter { $0 != apod.date }
                    }
                }
            }
        }

        if cachedApods.count == 7 {
//            cached apods is full (count == 7)
            print("fully cached apods")
            dataDelegate?.isFinishedLoadingAPOD()
            dataDelegate?.retrievedWeekOfAPOD(apods: cachedApods)
            return
        }
        
        start = datesFor(count: 7).last!
        end = currentDateString()
        print("new start: \(start)")
        print("new end: \(end)")
        
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=\(key)&start_date=\(start)&end_date=\(end)"
        
        guard let url = URL(string: urlString), canOpenUrl(url: url) else { return }
        
        URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            if error == nil && data != nil {
                getNumOfCallsLeft(response: response) { (callsLeft) in
                    print(callsLeft)
                    //enter group before and when the calls left is checked if there is enough left leave group and continue else up api key array counter +1 and then leave group
                }
                do {
                    let decoder = JSONDecoder()
                    apods = try decoder.decode([APOD].self, from: data!)
                    dispatch.leave()
                    print("just left")
                    
                    cache.checkForClear { (done) in
                        if done {
                            for apod in apods {
                                if !cache.isCached(date: apod.date) {
                                    cache.cache(apod: apod, date: apod.date)
                                }
                            }
                        }
                    }
                    
                } catch {
                    print("error parsing")
                    dispatch.leave()
                }
            }
        }.resume()
    
        dispatch.notify(queue: .main) { [self] in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            if apods.count == 7 {
                //cache was empty && apods are full (count == 7)
                print("cache was empty: got all the stuff")
                dataDelegate?.retrievedWeekOfAPOD(apods: reverseArray(array: apods))
                dataDelegate?.isFinishedLoadingAPOD()
            } else if apods.count == 0 && cachedApods.count == 0 {
                print("got nothing from cache nor api")
                dataDelegate?.noDataReceived()
            } else {
                let combined = apods + cachedApods
                let filtered = Array(Set(combined))
                let sorted = filtered.sorted(by: { $0.date > $1.date })
                print("some of it was cached")
                dataDelegate?.retrievedWeekOfAPOD(apods: sorted)
                dataDelegate?.isFinishedLoadingAPOD()
            }
//            }
        }
    }
    
    //------------------------------------------------------------------
    //MARK: num of calls left
    //------------------------------------------------------------------
    
    public func getNumOfCallsLeft(response: URLResponse?, completion: @escaping (Int) -> Void) {
        if let httpResponse = response as? HTTPURLResponse {
            if let callsLeft = httpResponse.allHeaderFields["X-RateLimit-Remaining"] as? String {
//                print(callsLeft)
                completion(Int(callsLeft) ?? 0)
            }
        } else {
            print("failed to make http resoponse")
        }
    }
    
    //------------------------------------------------------------------
    //MARK: dates for count
    //------------------------------------------------------------------
    
    public func datesFor(count: Int) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var result = [String]()
        
        for i in 0..<count {
            let date = Date().addingTimeInterval(TimeInterval(86400 * (i * -1)))
            result.append(formatter.string(from: date))
        }
        
        return result
    }
}
