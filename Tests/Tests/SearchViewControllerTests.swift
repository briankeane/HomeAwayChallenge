//
//  SearchViewControllerTests.swift
//  HomeAwayChallengeTests
//
//  Created by Brian D Keane on 12/13/18.
//  Copyright © 2018 Brian D Keane. All rights reserved.
//

@testable import HomeAwayChallenge
import XCTest
import Quick
import Nimble

class SearchViewControllerTests: QuickSpec {

    override func spec()
    {
        describe("SearchViewController")
        {
            var navigationController:UINavigationController!
            var searchVC:SearchViewController!
            var favoriterMock:FavoriterMock!
            var apiMock:APIMock!
            var events:[Event]!
            
            func loadMocks() {
                apiMock = APIMock()
                favoriterMock = FavoriterMock()
                favoriterMock.clearAll()
                
                events = []
                for i in 0...10 {
                    events.append(Event(id: i, title: "title_\(i)", eventDateTime: Date(), displayLocation: "location_\(i)", imageURL: nil))
                }
                apiMock.searchEventsResults = events
            }
            
            func setupViewController() {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                navigationController = UINavigationController()
                searchVC = (storyboard.instantiateViewController(withIdentifier: kSearchViewController) as! SearchViewController)
                
                UIApplication.shared.keyWindow?.rootViewController = navigationController
                
                navigationController.pushViewController(searchVC, animated: false)
                
                searchVC.setValuesForKeys([
                    "api": apiMock,
                    "favoriter": favoriterMock,
                    ])
                
                let _ = searchVC.view
            }
            
            beforeEach
            {
                loadMocks()
                setupViewController()
            }
            
            it ("performs a search and displays results accurately")
            {
                searchVC.searchBar.text = "Randy Rogers Band"
                searchVC.searchBar(searchVC.searchBar, textDidChange: "Randy Rogers Band")
                expect(searchVC.searchResultsTableView.numberOfRows(inSection: 0)).to(equal(events.count))
                
                let cell = searchVC.searchResultsTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! EventTableViewCell
                expect(cell.titleLabel.text!).to(equal(events[1].title))
                expect(cell.dateTimeLabel.text!).to(equal(events[1].eventDateTimeDisplayText))
                expect(cell.locationLabel.text!).to(equal(events[1].displayLocation))
            }
            
            it ("cancels a search")
            {
                searchVC.searchBar.text = "Randy Rogers Band"
                searchVC.searchBar(searchVC.searchBar, textDidChange: "Randy Rogers Band")
                expect(searchVC.searchResultsTableView.numberOfRows(inSection: 0)).to(beGreaterThan(0))
                searchVC.searchBarCancelButtonClicked(searchVC.searchBar)
                expect(searchVC.searchResultsTableView.numberOfRows(inSection: 0)).to(equal(0))
                expect(searchVC.searchBar.text).to(equal(""))
            }
            
            it ("accurately displays favorites")
            {
                searchVC.searchBar.text = "Randy Rogers Band"
                searchVC.searchBar(searchVC.searchBar, textDidChange: "Randy Rogers Band")
                favoriterMock.favorite(id: events[2].id)
                let favoritedCell = searchVC.searchResultsTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! EventTableViewCell
                let notFavoritedCell = searchVC.searchResultsTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! EventTableViewCell
                expect(favoritedCell.favoritesButton.imageView?.image).to(equal(UIImage(named: "heart")))
                expect(notFavoritedCell.favoritesButton.imageView?.image).to(beNil())
            }
            
            it ("responds to favoriting")
            {
                searchVC.searchBar.text = "Randy Rogers Band"
                searchVC.searchBar(searchVC.searchBar, textDidChange: "Randy Rogers Band")
                
                let cell = searchVC.searchResultsTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! EventTableViewCell
                
                // make sure it's not marked as favorited to begin with
                expect(cell.favoritesButton.imageView?.image).to(beNil())
                
                favoriterMock.favorite(id: events[1].id)
                
                expect{
                    let cell = searchVC.searchResultsTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! EventTableViewCell
                    return cell.favoritesButton.imageView?.image
                }.toEventually(equal(UIImage(named: "heart")))
            }
            
            it ("displays the correct detailView when UITableView is selected")
            {
                searchVC.searchBar.text = "Randy Rogers Band"
                searchVC.searchBar(searchVC.searchBar, textDidChange: "Randy Rogers Band")
                searchVC.tableView(searchVC.searchResultsTableView, didSelectRowAt: IndexPath(row: 2, section: 0))
                expect(navigationController.topViewController).toEventually(beAKindOf(DetailViewController.self))
                let detailVC = navigationController.topViewController as! DetailViewController
                expect(detailVC.event?.id).to(equal(searchVC.searchResults[2].id))
            }
            
            it ("displays the searchBarEmpty view when the search bar is empty")
            {
                searchVC.searchBar.text = ""
                searchVC.searchBar(searchVC.searchBar, textDidChange: "")
                expect(searchVC.searchResultsTableView.numberOfRows(inSection: 0)).to(equal(0))
                expect(searchVC.searchBarEmptyView.isHidden).toEventually(beFalse())
            }
            
            it ("removes the searchBarEmpty view when there are results")
            {
                searchVC.searchBar.text = "Randy Rogers Band"
                searchVC.searchBar(searchVC.searchBar, textDidChange: "Randy Rogers Band")
                expect(searchVC.searchResultsTableView.numberOfRows(inSection: 0)).to(beGreaterThan(0))
                expect(searchVC.searchBarEmptyView.isHidden).toEventually(beTrue())
            }
            
            it ("removes the searchBarEmpty view when there are results")
            {
                searchVC.searchBarCancelButtonClicked(searchVC.searchBar)
                expect(searchVC.searchResultsTableView.numberOfRows(inSection: 0)).to(equal(0))
                expect(searchVC.searchBarEmptyView.isHidden).toEventually(beFalse())
            }
        }
    }
}
