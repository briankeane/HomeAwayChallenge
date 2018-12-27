//
//  AlertDisplayer.swift
//  HomeAwayChallenge
//
//  Created by Brian D Keane on 12/27/18.
//  Copyright © 2018 Brian D Keane. All rights reserved.
//

import Foundation
import UIKit

class AlertDisplayer:NSObject {
     func displayAlert(_ presentingVC: UIViewController, title: String, message: String, completion: (() -> ())?=nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,
        handler: {
            action in
            completion?()
        }))
        presentingVC.present(alert, animated: true)
    }
}
