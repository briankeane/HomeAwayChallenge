//
//  ViewController.swift
//  homeAwayChallenge
//
//  Created by Brian D Keane on 12/10/18.
//  Copyright © 2018 Brian D Keane. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {



    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    
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
    
    func setupTableView() {
        self.searchResultsTableView.delegate = self
        self.searchResultsTableView.dataSource = self
    }
    
    //------------------------------------------------------------------------------
    
    func setupSearchBar() {
        self.searchBar.setTextFieldColor(color: UIColor(red: 0.165, green: 0.275, blue: 0.345, alpha: 1.00))
        self.searchBar.barStyle = .black
    }
    
    //------------------------------------------------------------------------------
    
    //
    // ensure proper statusBar color
    //
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //------------------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
}

