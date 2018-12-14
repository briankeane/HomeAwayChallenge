//
//  APITests.swift
//  homeAwayChallengeTests
//
//  Created by Brian D Keane on 12/11/18.
//  Copyright © 2018 Brian D Keane. All rights reserved.
//

@testable import homeAwayChallenge
import XCTest
import Quick
import Nimble
import OHHTTPStubs

class APITests: QuickSpec {
    //
    // for reading sample responses
    //
    private func readLocalJsonFile(_ filename:String!) -> [String:AnyObject]? {
        if let urlPathString = OHPathForFile(filename, type(of: self)) {
            do {
                let urlPath = URL(fileURLWithPath: urlPathString)
                let jsonData = try Data(contentsOf: urlPath, options: .mappedIfSafe)
                
                if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: AnyObject] {
                    return jsonDict
                }
            } catch let jsonError {
                print(jsonError)
            }
        }
        return nil
    }
    
    override func spec()
    {
        describe ("API")
        {
            var api:API!
            
            beforeEach
            {
                api = API()
            }
            
            afterSuite
            {
                OHHTTPStubs.removeAllStubs()
            }
            
            //------------------------------------------------------------------------------
            
            describe("dateFromString()")
            {
                it ("gracefully returns nil if argument is also nil")
                {
                    let date = api.dateFromString(dateString: nil)
                    expect(date).to(beNil())
                }
                
                it ("successfully creates a date from an api string")
                {
                    let date = api.dateFromString(dateString: "2018-12-12T19:00:00")
                    expect(date).to(equal(Date(timeIntervalSince1970: 1544662800.0)))
                }
            }
            
            //------------------------------------------------------------------------------
            
            describe("API Tests")
            {
                var sentRequest:URLRequest?
                var stubbedResponse:OHHTTPStubsResponse?
                var sentBody:[String:Any]?
                
                beforeEach
                {
                    sentBody = nil
                    sentRequest = nil
                    api = API()
                    
                    //
                    // stub and record requests
                    //
                    stub(condition: isHost("api.seatgeek.com"))
                    {
                        (request) in
                        if (sentRequest == nil)
                        {
                            sentRequest = request
                        }
                        
                        let castRequest = request as NSURLRequest
                        if let bodyData = castRequest.ohhttpStubs_HTTPBody()
                        {
                            // only capture initial sentBody
                            if (sentBody == nil)
                            {
                                sentBody = try! JSONSerialization.jsonObject(with: bodyData) as! [String:Any]
                            }
                        }
                        return stubbedResponse!
                    }
                }
                
                //------------------------------------------------------------------------------
                
                describe("Search")
                {
                    it ("works")
                    {
                        //
                        // setup
                        //
                        stubbedResponse = OHHTTPStubsResponse(
                                            fileAtPath: OHPathForFile("searchEventsSuccess.json", type(of: self))!,
                                            statusCode: 200,
                                            headers: ["Content-Type":"application/json"]
                                        )
                        waitUntil()
                        {
                            (finished) in
                            let jsonDict = self.readLocalJsonFile("searchEventsSuccess.json")
                            
                            api.searchEvents(searchText: "Boston Celtics"
                            , completion:
                            {
                                (foundEvents) in
                                // check request was made properly
                                expect(sentRequest!.url!.path).to(equal("/2/events"))
                                expect(sentRequest!.httpMethod).to(equal("GET"))
                                
                                //
                                // check query items
                                //
                                let components = URLComponents(url: sentRequest!.url!, resolvingAgainstBaseURL: false)
                                let actualQueryItems = components!.queryItems
                                let expectedQueryItems = [
                                    URLQueryItem(name: "q", value: "Boston Celtics"),
                                    URLQueryItem(name: "client_id", value: SeatGeekKeys.clientID)
                                ]
                                expect(actualQueryItems).to(contain(expectedQueryItems))
                                
                                //
                                // check parsing was successful
                                //
                                let event = foundEvents[0]
                                let responseEvent = (jsonDict?["events"] as! [Dictionary<String, Any?>])[0]
                                let expectedDisplayLocation = (responseEvent["venue"] as! [String:Any?])["display_location"] as! String
                                let expectedImageURLString = ((responseEvent["performers"]) as! [[String:Any?]])[0]["image"] as! String
                                let expectedTitle = responseEvent["title"] as! String
                                let expectedDateTime = api.dateFromString(dateString: (responseEvent["datetime_local"] as! String))!
                                let expectedID = responseEvent["id"] as! Int
                                
                                expect(event.displayLocation).to(equal((expectedDisplayLocation)))
                                expect(event.imageURL!.absoluteString).to(equal(expectedImageURLString))
                                expect(event.title).to(equal(expectedTitle))
                                expect(event.eventDateTime).to(equal(expectedDateTime))
                                expect(event.id).to(equal(expectedID))
                                finished()
                            }, onError: {
                                (err) in
                                print(err)
                                fail("There should not have been an error")
                            })
                        }
                    }
                    
                    //------------------------------------------------------------------------------
                    
                    it ("gracefully handles a server error")
                    {
                        // setup
                        stubbedResponse = OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("404.json", type(of: self))!,
                            statusCode: 404,
                            headers: [:]
                        )
                        
                        // test
                        waitUntil()
                        {
                            (finished) in
                            api.searchEvents(searchText: "Boston Celtics"
                            , completion: {
                                (events) in
                                fail("this call should not have succeeded")
                                
                            }, onError: {
                                (error) in
                                expect((error as NSError).code).to(equal(1001))
                                expect((error as NSError).userInfo["message"] as? String).to(equal("There was a problem with the server. Please try again later."))
                                finished()
                            })
                        }
                    }
                    
                    //------------------------------------------------------------------------------
                    
                    it ("gracefully handles no internet connection")
                    {
                        //
                        // simulate not connected to internet...
                        //
                        stubbedResponse = OHHTTPStubsResponse(error: NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue))
                        
                        // test
                        waitUntil()
                        {
                            (finished) in
                            api.searchEvents(searchText: "BostonCeltics"
                            , completion: {
                                (events) in
                                fail("searchEvents should not have succeeded")
                            }, onError: {
                                (err) in
                                let nsError = err as NSError
                                expect(nsError.domain).to(equal(NSURLErrorDomain))
                                expect(nsError.code).to(equal(URLError.notConnectedToInternet.rawValue))
                                finished()
                            })
                        }
                    }
                }
                
            }
            
        }
    }

}
