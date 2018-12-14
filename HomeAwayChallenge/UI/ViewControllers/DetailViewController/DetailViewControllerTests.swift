//
//  DetailViewControllerTests.swift
//  homeAwayChallengeTests
//
//  Created by Brian D Keane on 12/13/18.
//  Copyright © 2018 Brian D Keane. All rights reserved.
//

@testable import homeAwayChallenge
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
                let event = Event(id: 1, title: "bob", eventDateTime: Date(), displayLocation: "Hell", imageURL: nil)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                navigationController = UINavigationController()
                detailVC = (storyboard.instantiateViewController(withIdentifier: kDetailViewController) as! DetailViewController)
                
                UIApplication.shared.keyWindow?.rootViewController = navigationController
                
                navigationController.pushViewController(detailVC, animated: false)
                
                detailVC.setValuesForKeys([
                    "favoriter": favoriterMock,
                    ])
                
                let _ = detailVC.view
            }
            
            beforeEach {
                setupViewController()
            }
            
            it ("displays all the info correctly")
            {
                
            }
            
            it ("favorites")
            {
                
            }
            
            it ("responds to successful favorite")
            {
                
            }
        }
    }

}
