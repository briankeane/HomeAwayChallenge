//
//  Event+dateTimeDisplayTextTests.swift
//  HomeAwayChallengeTests
//
//  Created by Brian D Keane on 12/13/18.
//  Copyright © 2018 Brian D Keane. All rights reserved.
//

@testable import HomeAwayChallenge
import XCTest
import Quick
import Nimble

class Event_dateTimeDisplayTextTests: QuickSpec {
    override func spec() {
        describe("Event+dateTimeDisplayText")
        {
            var event:Event!
            var date:Date!
            
            beforeEach
            {
                var dateComponents = DateComponents()
                dateComponents.year = 1983
                dateComponents.month = 4
                dateComponents.day = 15
                dateComponents.timeZone = TimeZone(abbreviation: "CST") // Central Standard Time
                dateComponents.hour = 8
                let calendar = Calendar.current
                date = calendar.date(from: dateComponents)
                
                event = Event(id: 123, title: "My Badass Event", eventDateTime: date, displayLocation: "Hell", imageURL: nil)
            }
            
            it ("constructs the most beautiful string ever for the dateTime")
            {
                expect(event.eventDateTimeDisplayText).to(equal("Fri, 15 Apr 1983 8:00 AM"))
            }
        }
    }
}
