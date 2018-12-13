//
//  DetailViewController.swift
//  homeAwayChallenge
//
//  Created by Brian D Keane on 12/11/18.
//  Copyright © 2018 Brian D Keane. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var event:Event?
    
    //
    // dependency injections
    //
    @objc var favoriter:Favoriter = Favoriter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.event?.title
        
        self.setupNavigationBar()
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func addTapped() {
        // if it's favorited already
        if (self.favoriter.isFavorited(id: self.event!.id)) {
            self.favoriter.unFavorite(id: self.event!.id)
        } else {
            self.favoriter.favorite(id: self.event!.id)
        }
    }
    
    func setupNavigationBar() {
        self.setupMultiLineTitle()
        self.setupFavoritesBarButton()
    }
    
    func setupFavoritesBarButton() {
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "addToFavorites")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(DetailViewController.addTapped))
        rightBarButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        rightBarButtonItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        rightBarButtonItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        rightBarButtonItem.customView?.contentMode = .scaleAspectFit
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func setupMultiLineTitle() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.text = self.title!
    
        self.navigationItem.titleView = label
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
