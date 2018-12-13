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
        }
    }
}
