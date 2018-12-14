//
//  Vibrator.swift
//  homeAwayChallenge
//
//  Created by Brian D Keane on 12/13/18.
//  Copyright © 2018 Brian D Keane. All rights reserved.
//

import UIKit

/// Handles haptic feedback
class Vibrator: NSObject {
    //
    // explicitly store observers for clean memory on termination
    //
    var observers:[NSObjectProtocol] = Array()
    
    override init() {
        super.init()
        self.setupListeners()
    }
    
    
    //
    // listens for favorite and unfavorite events and buzzes for either
    //
    func setupListeners() {
        self.observers.append(NotificationCenter.default.addObserver(forName: FavoriterEvents.FAVORITE_CREATED, object: nil, queue: .main) {
            (notification) in
            self.buzz()
        })
    }
    
    func buzz() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    deinit {
        for observer in self.observers {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    /**
    provides a Singleton of the Vibrator for all to use
    
    - returns:
        `Vibrator` - the central Vibrator instance
    
    */
    public class func sharedInstance() -> Vibrator
    {
        if (self._instance == nil)
        {
            self._instance = Vibrator()
        }
        return self._instance!
    }
    
    /// internally shared singleton instance
    fileprivate static var _instance:Vibrator?
}
