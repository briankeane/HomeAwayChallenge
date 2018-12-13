//
//  Event+dateTimeDisplayText.swift
//  homeAwayChallenge
//
//  Created by Brian D Keane on 12/13/18.
//  Copyright © 2018 Brian D Keane. All rights reserved.
//

import Foundation

extension Event {
    var eventDateTimeDisplayText:String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM yyyy h:mm a"
        return formatter.string(from: self.eventDateTime)
    }
}
