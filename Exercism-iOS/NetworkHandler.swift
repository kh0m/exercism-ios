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
    
    class func getExercises() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if let exKey = Exercism["apiKey"] {
            let url = NSURL(string: "http://exercism.io/api/v1/exercises?key=\(exKey)")
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(dataString)
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? NSDictionary
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
            }
            
            task.resume()
        }
    }
    
    class func getSubmissionKey(exercise: Exercise) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if let exKey = Exercism["apiKey"] {
            let url = NSURL(string: "http://exercism.io/api/v1/submissions/\(exercise.language)/\(exercise.name)?key=\(exKey)")
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(dataString)
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? NSDictionary
                    
                    print(json!["url"])
                    let jsonurl = json!["url"] as! String
                    let newurl = jsonurl.stringByReplacingOccurrencesOfString("exercism.io", withString: "exercism.io/api/v1")
                    let nsurl = NSURL(string: newurl)!
                    
                    self.getIterations(nsurl)
                    
                    print("app languages: \(appDelegate.appData.languages.count)")
                    
                } catch {
                    print(error)
                }
            }
            task.resume()
        }

    }
    
    private class func getIterations(url: NSURL) {
        print(url)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(dataString)
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? NSDictionary
                print(json!)
            } catch {
                print(error)
            }
        }
        task.resume()

    }
}











