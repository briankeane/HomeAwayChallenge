//
//  AlertDisplayerMock.swift
//  HomeAwayChallenge
//
//  Created by Brian D Keane on 12/27/18.
//  Copyright © 2018 Brian D Keane. All rights reserved.
//

import Foundation
import UIKit

class AlertDisplayerMock:AlertDisplayer {
    var displayAlertArgs:[[String:Any]] = Array()
    var displayAlertCallCount:Int = 0
    
    override func displayAlert(_ presentingVC: UIViewController, title: String, message: String, completion: (() -> ())?=nil) {
        displayAlertArgs.append([
            "presentingVC"  :   presentingVC,
            "title"         :   title,
            "message"       :   message
                ])
        displayAlertCallCount += 1
        completion?()
    }
}
