//
//  DetailViewController.swift
//  HomeAwayChallenge
//
//  Created by Brian D Keane on 12/11/18.
//  Copyright © 2018 Brian D Keane. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    var observers:[NSObjectProtocol] = Array()
    
    @IBOutlet weak var performerImageView: UIImageView!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var event:Event?
    var rightBarButtonItem:UIBarButtonItem!
    
    //
    // dependency injections
    //
    @objc var favoriter:Favoriter = Favoriter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = self.event?.title
        
        setupNavigationBar()
        setupListeners()
        fillData()
    }
    
    //
    // MARK: - Event Responses
    //
    func setupListeners() {
        observers.append(NotificationCenter.default.addObserver(forName: FavoriterEvents.FAVORITE_CREATED, object: nil, queue: .main, using: {
            (notification) in
            guard let id = notification.userInfo?["id"] as? Int else {
                return
            }
            guard id == self.event!.id else {
                return
            }
            self.reloadFavoritesButton()
        }))
        observers.append(NotificationCenter.default.addObserver(forName: FavoriterEvents.FAVORITE_REMOVED, object: nil, queue: .main, using: {
            (notification) in
            guard let id = notification.userInfo?["id"] as? Int else {
                return
            }
            guard id == self.event!.id else {
                return
            }
            self.reloadFavoritesButton()
        }))
    }
    
    
    func reloadFavoritesButton() {
        DispatchQueue.main.async {
            if (self.favoriter.isFavorited(id: self.event!.id)) {
                if self.rightBarButtonItem.image != UIImage(named: "unfavorite") {
                    self.rightBarButtonItem.image = UIImage(named: "unfavorite")
                }
            } else {
                if self.rightBarButtonItem.image != UIImage(named: "favorite") {
                    self.rightBarButtonItem.image = UIImage(named: "favorite")
                }
            }
        }
    }
    
    @objc func addTapped() {
        // if it's favorited already
        if (favoriter.isFavorited(id: self.event!.id)) {
            favoriter.unFavorite(id: self.event!.id)
        } else {
            favoriter.favorite(id: self.event!.id)
        }
    }
    
    //
    // MARK: - UI Setup
    //
    
    func fillData() {
        performerImageView.kf.setImage(with: self.event!.imageURL)
        eventDateTimeLabel.text = self.event?.eventDateTimeDisplayText
        locationLabel.text = self.event?.displayLocation
    }
    
    func setupNavigationBar() {
        setupMultiLineTitleInNavBar()
        setupFavoritesBarButton()
    }
    
    func setupFavoritesBarButton() {
        let image = self.favoriter.isFavorited(id: self.event!.id) ? UIImage(named: "unfavorite") : UIImage(named: "favorite")
        rightBarButtonItem = UIBarButtonItem.init(image: image, style: .done, target: self, action: #selector(DetailViewController.addTapped))
        rightBarButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        rightBarButtonItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        rightBarButtonItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        rightBarButtonItem.customView?.contentMode = .scaleAspectFit
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func setupMultiLineTitleInNavBar() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.text = self.title!
        
        navigationItem.titleView = label
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
