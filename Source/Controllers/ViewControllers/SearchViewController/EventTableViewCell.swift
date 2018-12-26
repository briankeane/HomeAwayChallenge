//
//  EventTableViewCell.swift
//  HomeAwayChallenge
//
//  Created by Brian D Keane on 12/12/18.
//  Copyright © 2018 Brian D Keane. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var performerImageView: UIImageView!
    @IBOutlet weak var favoritesButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        performerImageView.clipsToBounds = true
        performerImageView.layer.cornerRadius = 8
        
    }

    @IBAction func favoritesButtonTapped(_ sender: Any) {
        
    }
    
    
}
