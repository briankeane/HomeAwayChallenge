//
//  Favoriter.swift
//  homeAwayChallenge
//
//  Created by Brian D Keane on 12/11/18.
//  Copyright © 2018 Brian D Keane. All rights reserved.
//

import UIKit

class Favoriter: NSObject {
    
    let key = "HOME_AWAY_CHALLENGE_FAVORITES"
    
    //
    // UserDefaults for quick and easy.  Later on prob would replace
    // with a CoreData implementation
    //
    
    /// clear all favorites
    open func clearAll() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach {
            (key) in
            if (key.hasPrefix("favorite_")) {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    /// sets a favorite
    open func favorite(id:Int) -> Void {
        let alreadyExisted:Bool = self.isFavorited(id: id)
        UserDefaults.standard.set(true, forKey: "favorite_\(id)")
        if (!alreadyExisted) {
            NotificationCenter.default.post(name: FavoriterEvents.FAVORITE_CREATED, object: nil, userInfo: ["id": id])
        }
    }
    
    /// releases a favorite
    open func unFavorite(id:Int) -> Void {
        let alreadyExisted:Bool = self.isFavorited(id: id)
        UserDefaults.standard.set(nil, forKey: "favorite_\(id)")
        if (alreadyExisted) {
            NotificationCenter.default.post(name: FavoriterEvents.FAVORITE_REMOVED, object: nil, userInfo: ["id": id])
        }
    }
    
    /// checks to see if an id has been favorited
    open func isFavorited(id:Int) -> Bool {
        return (UserDefaults.standard.bool(forKey: "favorite_\(id)") == true)
    }
}
