# Home Away Challenge	


## Building Locally

1. Copy the contents of `Source/Config/Keys-Example.swift` to a new file called `Keys.swift` in the same folder.  
2. Fill in the secret keys with your own seatGeek api info.

## Dependencies:
Dependencies are managed with CocoaPods.  The Pods folder is checked into the repo so no `pod install` is necessary

1. [Alamofire](https://github.com/Alamofire/Alamofire) -- I know it's just one request, but I figure if this was real, we'd be adding to it.
2. [Quick](https://github.com/Quick/Quick) and [Nimble](https://github.com/Quick/Nimble) -- I'm fluent in XCTest but I looove the way the Quick and Nimble make the tests so readable.
3. [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) -- because parsing JSON is one of the few things I don't like to do in Swift.
4. [Kingfisher](https://github.com/onevcat/Kingfisher) -- saved me a lot of imageView code in the searchResultsTableView

## Overview

#### Utilities
1. `API.swift` -- handles all networking 
2. `Favoriter.swift` -- handles favoriting
3.	`Vibrator.swift` -- haptic feedback
 
#### Config
1. `Constants.swift` -- I like to store string identifiers here to avoid spelling mistakes.
2. `Keys.swift` -- stores everything I do not want in my repository.

#### UI
1. The `ViewControllers` folders contain all files that relate to a single viewController.
2. The `UI-Related-Extensions` contains extensions on UI components as well as other extensions that relate only to the UI (in this case, the computed `eventDateTimeDisplayText` property, since it's functionality relates only to the display).


## Testing

* I like tests.  :)
* **Tests:** -- located in `Tests/Tests`
* **Mocks:** -- located in `Tests/Mocks`
* **Sample Responses** -- network communication is tested against the actual API responses in `Tests/SampleResponses`


## Thanks

Thanks for having a cool and fun challenge -- it was a blast to make.  I hope you enjoy digging through it!
