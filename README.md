# Home Away Challenge	


## Building Locally

1. Create a new file at `Source/Resources/Keys.swift` and fill it with the contents of `Source/Resources/Keys-Example.swift`.  
2. Fill in the secret keys with your own seatGeek api info.

## Overview

#### Models
1. `Event.swift`

#### Views
1. `Main.stoyboard`
2. `DetailView.storyboard` -- I separated the DetailView for easy editing

#### Controllers
1. The `ViewControllers` folders contain all files that relate to a single viewController.
2. The `Extensions` contains extensions on UI components that relate entirely to their appearance.

#### Utilities
1. `API.swift` -- handles all networking.  On a larger app I would use priority Dispatch Queues, separate parsing into a separate service, and provide a more detailed error handling service.
2. `Favoriter.swift` -- handles favoriting
3. `Vibrator.swift` -- haptic feedback
4. `AlertDisplayer.swift` -- App-wide alert message handler for uniformity.
 
#### Resources
1. `Constants.swift` -- I like to store string identifiers here to avoid spelling mistakes.
2. `Keys.swift` -- stores everything I do not want in my repository.


#### Design Patterns Used

* `MVC`
	* Simple structure for a simple app

* `Observer`
	* since multiple viewControllers had to respond to a 'Favorite/Unfavorite' event

* `Observer/Singleton`
	* A Singleton `Vibrator` service made sense, so that it could watch for Favorite events and respond to them regardless of their origin.

* `Dependency Injection`
	* I used dependency injection to make isolated unit testing easy with mocks.  The `DisplayAlert`module would make it easy to change the appearance/behavior of all alerts across the app later.


## Testing

* I like tests.  :)
* **Tests:** -- located in `Tests/Tests`
* **Mocks:** -- located in `Tests/Mocks`
* **Sample Responses** -- network communication is tested against the actual API responses in `Tests/SampleResponses`

## Dependencies:
Dependencies are managed with CocoaPods.  The Pods folder is checked into the repo so no `pod install` is necessary

1. [Alamofire](https://github.com/Alamofire/Alamofire) -- I know it's just one request, but I figure if this was real, we'd be adding to it.
2. [Quick](https://github.com/Quick/Quick) and [Nimble](https://github.com/Quick/Nimble) -- I'm fluent in XCTest but I looove the way the Quick and Nimble make the tests so readable.
3. [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) -- because parsing JSON is one of the few things I don't like to do in Swift.
4. [Kingfisher](https://github.com/onevcat/Kingfisher) -- saved me a lot of imageView code in the searchResultsTableView

## Thanks

Thanks for having a cool and fun challenge -- it was a blast to make. 
