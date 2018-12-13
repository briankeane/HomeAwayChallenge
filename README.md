# Home Away Challenge	

First off -- thanks for the really fun challenge.  It's just big enough to allow you to try some fun stuff, but it doesn't take long at all.

## Building Locally

1. Copy the contents of `homeAwayChallenge/Config/Keys-Example.swift` to a new file called `Keys.swift` in the same folder.  
2. Fill in the secret keys with your own seatGeek api info.

## External Libraries Used:

1. [Alamofire](https://github.com/Alamofire/Alamofire) -- I know it's just one request, but I figure if this was real, we'd be adding to it.
2. [Quick](https://github.com/Quick/Quick) and [Nimble](https://github.com/Quick/Nimble) -- I'm fluent in XCTest but I looove the way the Quick and Nimble make the tests so readable.
3. [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) -- because parsing JSON is one of the few things I don't like to do in Swift.
4. [Kingfisher](https://github.com/onevcat/Kingfisher) -- saved me a lot of imageView code in the searchResultsTableView

## Important Files and Folders

#### Utilities
1. `API.swift` -- handles all networking (yeah, yeah I know... 1 request) :)
2. `Favoriter.swift` -- handles favoriting

#### Config
1. `Constants.swift` -- I like to store string identifiers here to avoid spelling mistakes.
2. `Keys.swift` -- stores everything I do not want in my repository.

#### UI
1. The `ViewControllers` folders contain all files that relate to a single viewController.
2. The `UI-Related-Extensions` contains extensions on UI components as well as other extensions that relate only to the UI (in this case, the computed `eventDateTimeDisplayText` property, since it's functionality relates only to the display).


## Testing

* I like tests.  :)
* **Location:** Test files are right next to the file that they are testing.
* **JSON:** I like to test against the actual responses, so I copy/paste them into separate JSON files and parse them in the tests. (See `  This makes it really easy to add edge-cases or incorporate any changes in the api.  Examples of this are in `homeAwayChallengeTests/SampleResponses` folder.


## Strengths
1. **General Badassness**, if I do say so myself. :)
2. **Cleanliness/Readability** -- I like for coders who jump into my code in the middle to understand exactly what's happening.
3. **Modularity** -- Over the last couple years, I've gotten much better at making each module easily replaceable.
4. **Practical Testing** -- I think I have a pretty good feel for writing tests that make the project more maintainable instead of less changeable (which I've found to be more difficult than it sounds).

## Areas for Improvement
1. **Design** -- In all of my projects, I have to hire an outside designer if I want it to look really pro.  I'd love to learn how to be a little more self-reliant at it, but for now I find it very tough.
2. 