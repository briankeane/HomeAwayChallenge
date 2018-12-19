//
//  SearchViewController.swift
//  HomeAwayChallenge
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
    @IBOutlet weak var searchBarEmptyView: UIView!
    
    //
    // dependency injections
    //
    @objc var api:API! = API()
    @objc var favoriter:Favoriter! = Favoriter()
    
    /// stores all observers for cleanup in deinit
    var observers:[NSObjectProtocol] = Array()
    
    /// The current request
    var pendingRequest:Request?
    
    /// the current search results
    var searchResults:[Event] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
        setupListeners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    //
    // MARK: - Event Responses
    //
    
    func setupListeners() {
        observers.append(NotificationCenter.default.addObserver(forName: FavoriterEvents.FAVORITE_CREATED, object: nil, queue: .main){
            (notification) in
            guard let id = notification.userInfo?["id"] as? Int else {
                return
            }
            self.reloadCellsWithID(id: id)
        })
        
        observers.append(NotificationCenter.default.addObserver(forName: FavoriterEvents.FAVORITE_REMOVED, object: nil, queue: .main) {
            (notification) in
            guard let id = notification.userInfo?["id"] as? Int else {
                return
            }
            self.reloadCellsWithID(id: id)
        })
    }
    
    //
    // reload cells where event matches id
    //
    func reloadCellsWithID(id:Int) {
        for (i, event) in self.searchResults.enumerated() {
            if (event.id == id) {
                searchResultsTableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: UITableView.RowAnimation.none)
            }
        }
    }
    
    //
    // MARK: - Search
    //
    
    func performSearch() {
        guard let searchText = self.searchBar.text,
            searchBar.text!.isEmpty != true else {
                return
        }
        
        pendingRequest?.cancel()
        
        api.searchEvents(searchText: searchText
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
                
        }) {
            (error) in
            print(error)
        }
    }
    
    func setupTableView() {
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        
        searchResultsTableView.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: kEventTableViewCell)
    }
    
    func setupSearchBar() {
        searchBar.setTextFieldColor(color: UIColor(red: 0.165, green: 0.275, blue: 0.345, alpha: 1.00))
        searchBar.barStyle = .black
        searchBar.delegate = self
        searchBar.setTextFieldTextColor(color: .white)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func showSearchBarEmptyView() {
        DispatchQueue.main.async {
            self.searchBarEmptyView.isHidden = false
        }
    }
    
    func hideSearchBarEmptyView() {
        DispatchQueue.main.async {
            self.searchBarEmptyView.isHidden = true
        }
    }
    
    //
    // MARK: - UISearchBarDelegate
    //
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (self.searchBar.text?.isEmpty == true) {
            clearSearchResults()
        } else {
            performSearch()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.searchBar(searchBar, textDidChange: "")    // manually call because it's not triggered
                                                        // automatically through programmatic change
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    private func clearSearchResults() {
        searchResults = Array()
        searchResultsTableView.reloadData()
    }
    
    //
    // MARK: - UITableViewDataSource & Delegate
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.searchResults.count == 0 ? showSearchBarEmptyView() : hideSearchBarEmptyView()
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = self.searchResults[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kEventTableViewCell, for: indexPath) as? EventTableViewCell else {
            return UITableViewCell()
        }
        formatCell(cell: cell, event: event)
        return cell
    }
    
    func formatCell(cell:EventTableViewCell, event: Event) {
        cell.titleLabel.text = event.title
        
        if let imageURL = event.imageURL {
            cell.performerImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "performer-placeholder"))
        } else {
            cell.performerImageView.image = UIImage(named: "image-not-available")
        }
        
        cell.locationLabel.text = event.displayLocation
        cell.dateTimeLabel.text = event.eventDateTimeDisplayText
        cell.selectionStyle = .none
        
        if (favoriter.isFavorited(id: event.id)) {
            cell.favoritesButton.setImage(UIImage(named: "heart"), for: .normal)
        } else {
            cell.favoritesButton.setImage(nil, for: .normal)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        let event = self.searchResults[indexPath.row]
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: kDetailViewController) as! DetailViewController
        detailVC.event = event
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //
    // MARK: - Cleanup
    //
    
    deinit {
        for observer in observers {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
