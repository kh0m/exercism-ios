//
//  NetworkHandler.swift
//  Exercism-iOS
//
//  Created by Hom, Kenneth on 4/2/16.
//  Copyright © 2016 Hom, Kenneth. All rights reserved.
//

import UIKit
import OAuthSwift
import CoreData

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
    
    class func getExercises(completion: () -> Void) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // first delete any instances of the Language entity
        let fetchRequest = NSFetchRequest(entityName: "Language")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.executeRequest(deleteRequest)
        } catch let error as NSError {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
        // then fill it
        if let exKey = Exercism["apiKey"] {
            let url = NSURL(string: "http://exercism.io/api/v1/exercises?key=\(exKey)")
            
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(dataString)
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? NSDictionary
                    
                    for (key, value) in json! {

                        let entity = NSEntityDescription.entityForName("Language", inManagedObjectContext: managedContext)
                        let lang = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! Language
                        
                        lang.name = key as? String
                        for v in (value as? NSArray)! {
                            let entity = NSEntityDescription.entityForName("Exercise", inManagedObjectContext: managedContext)
                            let ex = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                            
                            let name = v["slug"] as! String
                            ex.setValue(name, forKey: "name")
                            ex.setValue(lang, forKey: "language")

                            let isActive = (v["state"] as! String == "active" ? true : false)
                            ex.setValue(isActive, forKey: "isActive")
                        }
                    }
                    
                    do {
                        try managedContext.save()
                    } catch let error as NSError {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                    
                    completion()
                    
                } catch {
                    print(error)
                }
            }
            
            task.resume()
        }
    }
    

    class func getIterations() {
        if let exKey = Exercism["apiKey"] { // for when we get the real api

            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            // first delete any instances of the Iteration entity
            let fetchRequest = NSFetchRequest(entityName: "Iteration")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try managedContext.executeRequest(deleteRequest)
            } catch let error as NSError {
                print("Could not delete \(error), \(error.userInfo)")
            }
            
            // get all exercises
            let exercisesFetchRequest = NSFetchRequest(entityName: "Exercise")
            do {
                let exercises = try managedContext.executeRequest(exercisesFetchRequest)
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
            // get all iterations for each exercise
            let url = NSURL(string: "http://localhost:4567/api/v1/submissions/elixir/acronym/iterations?key=aug949") // currently just isaac
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? NSArray
                    for object in json! {
                        
                        let entity = NSEntityDescription.entityForName("Iteration", inManagedObjectContext: managedContext)
                        let iteration = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! Iteration
                        
                        let submission = object["submission"] as! NSDictionary
                        let solution = submission.valueForKey("solution") as! NSDictionary
                        let solutionCode = solution.allValues.first
                        iteration.code = solutionCode as? String
                        
                        let comments = object["comments"] as! NSArray
                        for comment in comments {
                            let comment = comment as! NSDictionary
                            
                            // insert into core data
                            let commentEntity = NSEntityDescription.entityForName("Comment", inManagedObjectContext: managedContext)
                            let managedComment = NSManagedObject(entity: commentEntity!, insertIntoManagedObjectContext: managedContext) as! Comment
                            managedComment.iteration = iteration
                            managedComment.text = comment.valueForKey("body") as? String // or should I use body
                        }
                    }
                    
                    do {
                        try managedContext.save()
                    } catch let error as NSError {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                    
                } catch {
                    print(error)
                }
                    
                    
                }
                task.resume()
        }
    }
    
    
    
    
    //    class func getSubmissionKey(exercise: Exercise) {
    //        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    //
    //        if let exKey = Exercism["apiKey"] {
    //            let url = NSURL(string: "http://exercism.io/api/v1/submissions/\(exercise.language)/\(exercise.name)?key=\(exKey)")
    //            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
    //                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
    //                print(dataString)
    //                do {
    //                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? NSDictionary
    //
    //                    print(json!["url"])
    //                    let jsonurl = json!["url"] as! String
    //                    let newurl = jsonurl.stringByReplacingOccurrencesOfString("exercism.io", withString: "exercism.io/api/v1")
    //                    let nsurl = NSURL(string: newurl)!
    //
    //                    self.getIterations(nsurl)
    //
    //                    print("app languages: \(appDelegate.appData.languages.count)")
    //
    //                } catch {
    //                    print(error)
    //                }
    //            }
    //            task.resume()
    //        }
    //
    //    }
    //
    //    private class func getIterations(url: NSURL) {
    //        print(url)
    //        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
    //            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
    //            print(dataString)
    //            do {
    //                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? NSDictionary
    //                print(json!)
    //            } catch {
    //                print(error)
    //            }
    //        }
    //        task.resume()
    //
    //    }
    //
}











