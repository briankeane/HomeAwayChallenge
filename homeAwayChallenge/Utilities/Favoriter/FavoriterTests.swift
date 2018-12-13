//
//  FavoriterTests.swift
//  homeAwayChallengeTests
//
//  Created by Brian D Keane on 12/11/18.
//  Copyright © 2018 Brian D Keane. All rights reserved.
//

@testable import homeAwayChallenge
import XCTest
import Quick
import Nimble

class FavoriterTests: QuickSpec {
    override func spec() {
        describe("Favoriter")
        {
            var favoriter:Favoriter!
            
            beforeEach
            {
                favoriter = Favoriter()
                favoriter.clearAll()
            }
            
            afterSuite
            {
                favoriter.clearAll()
            }
            
            it ("sets a favorite")
            {
                favoriter.favorite(id: 1)
                expect(favoriter.isFavorited(id: 1)).to(equal(true))
            }
            
            it ("releases a favorite")
            {
                favoriter.favorite(id: 2)
                favoriter.unFavorite(id: 2)
                expect(favoriter.isFavorited(id: 2)).to(equal(false))
            }
            
            it ("tells if a favorite is favorited")
            {
                favoriter.favorite(id: 3)
                expect(favoriter.isFavorited(id: 3)).to(equal(true))
                expect(favoriter.isFavorited(id: 1)).to(equal(false))
            }
            
            it ("clears all favorites")
            {
                favoriter.favorite(id: 1)
                favoriter.favorite(id: 2)
                favoriter.favorite(id: 3)
                favoriter.clearAll()
                expect(favoriter.isFavorited(id: 1)).to(equal(false))
                expect(favoriter.isFavorited(id: 2)).to(equal(false))
                expect(favoriter.isFavorited(id: 3)).to(equal(false))
                
            }
            describe ("Event Notifications")
            {
                it ("broadcasts a notification when a favorite is created")
                {
                    let notification = Notification(name: FavoriterEvents.FAVORITE_CREATED, object: nil, userInfo: ["id": 123])
                    expect {
                        favoriter.favorite(id: 123)
                    }.toEventually(postNotifications(contain([notification])))
                }
            
                it ("broadcasts a notification when a favorite is removed")
                {
                    let notification = Notification(name: FavoriterEvents.FAVORITE_REMOVED, object: nil, userInfo: ["id": 456])
                    favoriter.favorite(id: 456)
                    expect {
                        favoriter.unFavorite(id: 456)
                    }.toEventually(postNotifications(contain([notification])))
                }
                
                it ("does not broadcast when an item was already favorited")
                {
                    let notification = Notification(name: FavoriterEvents.FAVORITE_CREATED, object: nil, userInfo: ["id": 123])
                    favoriter.favorite(id: 123)
                    expect {
                        favoriter.favorite(id: 123)
                        }.toNotEventually(postNotifications(contain([notification])))
                }
                
                it ("does not broadcast when an item was already UNfavorited")
                {
                    let notification = Notification(name: FavoriterEvents.FAVORITE_REMOVED, object: nil, userInfo: ["id": 123])
                    favoriter.unFavorite(id: 123)
                    expect {
                        favoriter.unFavorite(id: 123)
                    }.toNotEventually(postNotifications(contain([notification])))
                }
            
            }
        }
    }
}
