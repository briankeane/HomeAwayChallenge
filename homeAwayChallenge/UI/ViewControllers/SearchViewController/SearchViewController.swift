//
//  ViewController.swift
//  homeAwayChallenge
//
//  Created by Brian D Keane on 12/10/18.
//  Copyright © 2018 Brian D Keane. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    //
    // dependency injections
    //
    @objc var api:API! = API()
    @objc var favoriter:Favoriter! = Favoriter()
    
    /// The current request
    var pendingRequest:Request?
    
    /// the current search results
    var searchResults:[Event] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearchBar()
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    //------------------------------------------------------------------------------
    
    func performSearch() {
        guard let searchText = self.searchBar.text,
            self.searchBar.text!.isEmpty != true else {
                return
        }
        
        self.pendingRequest?.cancel()
        
        self.api.searchEvents(searchText: searchText
        , completion:
            { (events) in
                //
                // check to make sure the results are for the
                // correct searchText
                //
                guard searchText == self.searchBar.text else {
                    return
                }
                
                self.searchResults = events
                self.searchResultsTableView.reloadData()
                
        }) { (error) in
            print(error)
        }
    }
    
    //------------------------------------------------------------------------------
    
    func setupTableView() {
        self.searchResultsTableView.delegate = self
        self.searchResultsTableView.dataSource = self
        
        
        self.searchResultsTableView.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: kEventTableViewCell)
    
    }
    
    //------------------------------------------------------------------------------
    
    func setupSearchBar() {
        self.searchBar.setTextFieldColor(color: UIColor(red: 0.165, green: 0.275, blue: 0.345, alpha: 1.00))
        self.searchBar.barStyle = .black
        self.searchBar.delegate = self
        self.searchBar.setTextFieldTextColor(color: .white)
    }
    
    //------------------------------------------------------------------------------
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (self.searchBar.text?.isEmpty == true) {
            clearSearchResults()
        } else {
            performSearch()
        }
    }
    
    //------------------------------------------------------------------------------
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar(searchBar, textDidChange: "")    // manually call because it's not triggered
                                                        // automatically
    }
    
    //------------------------------------------------------------------------------
    
    private func clearSearchResults() {
        self.searchResults = Array()
        self.searchResultsTableView.reloadData()
    }
    
    //------------------------------------------------------------------------------
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //------------------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = self.searchResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: kEventTableViewCell, for: indexPath) as! EventTableViewCell
        cell.titleLabel.text = event.title
        cell.performerImageView.kf.setImage(with: event.imageURL)
        cell.locationLabel.text = event.displayLocation
        cell.dateTimeLabel.text = event.eventDateTimeDisplayText
        cell.selectionStyle = .none
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let event = self.searchResults[indexPath.row]
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: kDetailViewController) as! DetailViewController
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

