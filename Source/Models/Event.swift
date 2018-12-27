//
//  Event.swift
//  HomeAwayChallenge
//
//  Created by Brian D Keane on 12/11/18.
//  Copyright © 2018 Brian D Keane. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Event {
    var id:Int
    var title:String
    var eventDateTime:Date
    var imageURL:URL?
    var displayLocation:String
    
    init(id:Int, title:String, eventDateTime:Date, displayLocation:String, imageURL:URL?) {
        self.id                 =   id
        self.title              =   title
        self.eventDateTime      =   eventDateTime
        self.displayLocation    =   displayLocation
        self.imageURL           =   imageURL
    }
}
