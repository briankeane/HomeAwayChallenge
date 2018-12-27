//
//  APIMock.swift
//  HomeAwayChallengeTests
//
//  Created by Brian D Keane on 12/13/18.
//  Copyright © 2018 Brian D Keane. All rights reserved.
//

@testable import HomeAwayChallenge
import UIKit
import Alamofire

class APIMock: API {
    
    var searchEventsResults:[Event]?
    var searchEventsError:Error?
    var searchEventsShouldError:Bool = false
    override func searchEvents(searchText: String, completion: @escaping ([Event]) -> Void, onError: @escaping (Error) -> Void) -> Request {
        if (searchEventsShouldError == true) {
            onError(searchEventsError!)
        } else {
            completion(searchEventsResults!)
        }
        return request(URL(string: "JUST_A_PLACEHOLDER")!)
    }
}
