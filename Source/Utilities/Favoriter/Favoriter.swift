//
//  Favoriter.swift
//  HomeAwayChallenge
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
    
    /**
     Wipes all the favorites.
     
     ### Usage Example: ###
     ````
     favoriter.clearAll()
     ````
     */
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
    
    /**
     Sets a favorite.  A FavoriterEvents.FAVORITE_CREATED event will be broadcast
     on success.
     
     - Parameter id: The ID of the event to favorite.
     
     ### Usage Example: ###
     ````
     favoriter.favorite(id: 123)
     ````
     */
    open func favorite(id:Int) -> Void {
        let alreadyExisted:Bool = isFavorited(id: id)
        UserDefaults.standard.set(true, forKey: "favorite_\(id)")
        if (!alreadyExisted) {
            NotificationCenter.default.post(name: FavoriterEvents.FAVORITE_CREATED, object: nil, userInfo: ["id": id])
        }
    }
    
    /**
     Removes a favorite.  A FavoriterEvents.FAVORITE_REMOVED event will be broadcast
     on success.
     
     - Parameter id: The ID of the event to remove.
     
     ### Usage Example: ###
     ````
     favoriter.unFavorite(id: 123)
     ````
     */
    open func unFavorite(id:Int) -> Void {
        let alreadyExisted:Bool = isFavorited(id: id)
        UserDefaults.standard.set(nil, forKey: "favorite_\(id)")
        if (alreadyExisted) {
            NotificationCenter.default.post(name: FavoriterEvents.FAVORITE_REMOVED, object: nil, userInfo: ["id": id])
        }
    }
    
    /**
     Checks to see if an id is currently favorited
     
     - Parameter id: The ID of the event to remove.
     
     ### Usage Example: ###
     ````
     favoriter.unFavorite(id: 123)
     ````
     
     - Returns: **true** if the item has been favorited
     */
    open func isFavorited(id:Int) -> Bool {
        return (UserDefaults.standard.bool(forKey: "favorite_\(id)") == true)
    }
}
