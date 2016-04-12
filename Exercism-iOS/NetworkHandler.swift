//
//  NetworkHandler.swift
//  Exercism-iOS
//
//  Created by Hom, Kenneth on 4/2/16.
//  Copyright © 2016 Hom, Kenneth. All rights reserved.
//

import UIKit
import OAuthSwift

class NetworkHandler: NSObject {
    
    class func getUser(oauthswift: OAuth2Swift) {
        if let token = Github["accessToken"] {
            oauthswift.client.request("http://localhost:4567/api_login", method: .GET,
                                      parameters: ["code" : token], headers: [:],
                success: { data, response in
                    let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    print(dataString)
                }, failure: { error in
                    print(error)
                }
            )
        }
    }
    
    class func getExercises(oauthswift: OAuth2Swift) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if let exKey = Exercism["apiKey"] {
            oauthswift.client.request("http://exercism.io/api/v1/exercises", method: .GET,
                                      parameters: ["key" : exKey], headers: [:],
                success: { data, response in
                    let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    print(dataString)
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? NSDictionary
                        for (key, value) in json! {
                            let lang = Language()
                            lang.name = key as! String
                            for v in (value as? NSArray)! {
                                let ex = Exercise()
                                ex.name = v["slug"] as! String
                                ex.language = key as! String
                                ex.isActive = (v["state"] as! String == "active" ? true : false)
                                lang.exercises.append(ex)
                            }
                            appDelegate.appData.languages.append(lang)
                        }
                        print("app languages: \(appDelegate.appData.languages.count)")

                    } catch {
                        print(error)
                    }
                }, failure: { error in
                    print(error)
                }
            )
        }
    }
    
    class func getSubmissionKey(oauthswift: OAuth2Swift, exercise: Exercise) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if let exKey = Exercism["apiKey"] {
            oauthswift.client.request("http://exercism.io/api/v1/submissions/\(exercise.language)/\(exercise.name)", method: .GET,
                                      parameters: ["key" : exKey], headers: [:],
                success: { data, response in
                    let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    print(dataString)
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? NSDictionary
                        
                        print(json!["url"])
                        let jsonurl = json!["url"] as! String
                        let newurl = jsonurl.stringByReplacingOccurrencesOfString("exercism.io", withString: "exercism.io/api/v1")
                        let nsurl = NSURL(string: newurl)!
                        
                        self.getIterations(oauthswift, url: nsurl)
                        
                        print("app languages: \(appDelegate.appData.languages.count)")
                        
                    } catch {
                        print(error)
                    }
                }, failure: { error in
                    print(error)
                }
            )
        }

    }
    
    class func getIterations(oauthswift: OAuth2Swift, url: NSURL) {
        print(url)
    }
}











