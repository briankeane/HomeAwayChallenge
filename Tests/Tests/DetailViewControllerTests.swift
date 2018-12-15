//
//  DetailViewControllerTests.swift
//  HomeAwayChallengeTests
//
//  Created by Brian D Keane on 12/13/18.
//  Copyright © 2018 Brian D Keane. All rights reserved.
//

@testable import HomeAwayChallenge
import XCTest
import Quick
import Nimble

class DetailViewControllerTests: QuickSpec {
    override func spec()
    {
        describe("DetailViewController")
        {
            var navigationController:UINavigationController!
            var detailVC:DetailViewController!
            var event:Event!
            var favoriterMock:FavoriterMock!
            
            func setupViewController() {
                event = Event(id: 1, title: "bob", eventDateTime: Date(), displayLocation: "Hell", imageURL: nil)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                navigationController = UINavigationController()
                detailVC = (storyboard.instantiateViewController(withIdentifier: kDetailViewController) as! DetailViewController)
                detailVC.event = event
                
                UIApplication.shared.keyWindow?.rootViewController = navigationController
                
                navigationController.pushViewController(detailVC, animated: false)
                
                detailVC.setValuesForKeys([
                    "favoriter": favoriterMock,
                    ])
                
                let _ = detailVC.view
            }
            
            beforeEach {
                favoriterMock = FavoriterMock()
                favoriterMock.clearAll()
                setupViewController()
            }
            
            it ("displays all the info correctly")
            {
                expect(detailVC.title).to(equal(event.title))
                expect(detailVC.eventDateTimeLabel.text).to(equal(event.eventDateTimeDisplayText))
                expect(detailVC.locationLabel.text).to(equal(event.displayLocation))
            }
            
            describe("favorites")
            {
                it ("initializes with correct barButtonItem for a favorite")
                {
                    expect(detailVC.rightBarButtonItem.image).to(equal(UIImage(named: "favorite")))
                }
                
                it ("initializes with correct barButtonItem for a non-favorited event")
                {
                    favoriterMock.favorite(id: event.id)
                    setupViewController()
                    expect(detailVC.rightBarButtonItem.image).to(equal(UIImage(named: "unfavorite")))
                }
                
                it ("responds to favoriting")
                {
                    favoriterMock.favorite(id: event.id)
                    expect(detailVC.rightBarButtonItem.image).toEventually(equal(UIImage(named: "unfavorite")))
                }
                
                it ("responds to unfavoriting")
                {
                    favoriterMock.favorite(id: event.id)
                    setupViewController()
                    favoriterMock.unFavorite(id: event.id)
                    expect(detailVC.rightBarButtonItem.image).toEventually(equal(UIImage(named: "favorite")))
                }
            }
        }
    }

}
