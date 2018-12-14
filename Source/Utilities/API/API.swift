//
//  API.swift
//  homeAwayChallenge
//
//  Created by Brian D Keane on 12/11/18.
//  Copyright © 2018 Brian D Keane. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class API: NSObject {
    var baseURL:String = "https://api.seatgeek.com"
    var clientID:String = SeatGeekKeys.clientID
    
    // MARK: - Helper Functions
    
    //
    // provides a date, given the type of string format used by the seatGeek api
    //
    public func dateFromString(dateString:String?) -> Date? {
        //
        // nil if dateString is nil
        //
        guard let dateString = dateString else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: dateString)!
    }
    
    // MARK: - API Calls
    
    /**
     Searches the seatgeek api for events
     
     - Parameters:
        - searchText: the string to search for
        - completion: completion closure that takes an array of Events
        - onError: error closure
     
     ### Usage Example: ###
     ````
     api.searchEvents(searchText: "Boston Celtics"
     , completion: {
        (foundEvents) in
        print(foundEvents[0].count)
     }, onError: {
        (err) in
        print(err)
     })
     ````
     */
    @discardableResult
    func searchEvents(searchText:String, completion: @escaping ([Event]) -> Void, onError: @escaping (Error) -> Void) -> Request {
        let url = "\(baseURL)/2/events"
        let parameters:Parameters = ["q": searchText,
                                     "client_id": self.clientID ]
        
        return Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
        .responseJSON {
            (response) -> Void in
            
            guard response.result.error == nil else {
                onError(response.result.error!)
                return
            }
            
            
            //
            // check for proper server communication
            //
            guard let statusCode = response.response?.statusCode,
                200..<300 ~= statusCode else {
                onError(NSError(domain:"", code:1001, userInfo:["message": "There was a problem with the server. Please try again later."]))
                return
            }
            
            //
            // check for properly formed server response
            //
            guard let rawValue = response.result.value else {
                onError(NSError(domain:"", code:1001, userInfo:["message": "There was an unknown problem parsing the response"]))
                return
            }
            
            //
            // parse it
            //
            let dataJSON = JSON(rawValue)
            
            guard let eventsJSON = dataJSON["events"].array else {
                onError(NSError(domain:"", code:1001, userInfo:["message": "There was an unknown problem parsing the response"]))
                return
            }
            
            var events:[Event] = Array()
            
            for eventJSON in eventsJSON {
                guard let title = eventJSON["title"].string else {
                    break
                }
                guard let eventDateTimeString = eventJSON["datetime_local"].string else {
                    break
                }
                guard let displayLocation = eventJSON["venue"]["display_location"].string else {
                    break
                }
                guard let id = eventJSON["id"].int else {
                    break
                }
                var imageURL:URL?
                if let performers = eventJSON["performers"].array {
                    if performers.count > 0 {
                        if let imageURLString = performers[0]["image"].string {
                            imageURL = URL(string: imageURLString)
                        }
                    }
                }
                events.append(Event(id: id, title: title, eventDateTime: self.dateFromString(dateString: eventDateTimeString)!, displayLocation: displayLocation, imageURL: imageURL))
            }
            
            completion(events)
        }
    }
}
