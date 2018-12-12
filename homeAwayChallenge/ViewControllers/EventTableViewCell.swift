//
//  EventTableViewCell.swift
//  homeAwayChallenge
//
//  Created by Brian D Keane on 12/12/18.
//  Copyright © 2018 Brian D Keane. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
