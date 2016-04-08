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
}
