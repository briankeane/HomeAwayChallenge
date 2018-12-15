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
        if (!favoriter.isFavorited(id: event!.id) && showingFavorited()) {
            animateToIsNotFavorite()
        } else if (favoriter.isFavorited(id: event!.id) && !showingFavorited()) {
            animateToIsFavorite()
        }
    }
    
    func showingFavorited() -> Bool {
        if let image = (rightBarButtonItem.customView as? UIButton)?.image(for: .normal) {
            if image == UIImage(named: "unfavorite") {
                return true
            }
        }
        return false
    }
    
    func animateToIsFavorite() {
        (rightBarButtonItem.customView as? UIButton)?.setImage(UIImage(named: "unfavorite"), for: .normal)
    }
    
    func animateToIsNotFavorite() {
        if let button = self.rightBarButtonItem.customView as? UIButton {
            //
            // unhook button during animation
            //
            button.removeTarget(self, action: #selector(DetailViewController.addTapped), for: .touchUpInside)
            
            
            button.setImage(UIImage(named: "brokenHeart"), for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                UIView.transition(with: button, duration: 0.3, options: .transitionFlipFromRight, animations: {
                    button.setImage(UIImage(named: "favorite"), for: .normal)
                })
                {
                    (completed) -> Void in
                    // reenable button
                    button.addTarget(self, action: #selector(DetailViewController.addTapped), for: .touchUpInside)
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
        if let imageURL = event?.imageURL {
            performerImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "performer-placeholder"))
        } else {
            performerImageView.image = UIImage(named: "image-not-available")
        }
        eventDateTimeLabel.text = self.event?.eventDateTimeDisplayText
        locationLabel.text = self.event?.displayLocation
    }
    
    func setupNavigationBar() {
        setupMultiLineTitleInNavBar()
        setupFavoritesBarButton()
    }
    
    func setupFavoritesBarButton() {
        let image = self.favoriter.isFavorited(id: self.event!.id) ? UIImage(named: "unfavorite") : UIImage(named: "favorite")
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0)
        button.addTarget(self, action: #selector(DetailViewController.addTapped), for: .touchUpInside)
        rightBarButtonItem = UIBarButtonItem(customView: button)
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
