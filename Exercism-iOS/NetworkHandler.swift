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
    
    var mainContext: NSManagedObjectContext?
    
    func getUser(oauthswift: OAuth2Swift) {
        if let token = Github["accessToken"] {
            oauthswift.client.request("http://localhost:4567/api_login", method: .GET,
                                      parameters: ["code" : token], headers: [:],
                success: { data, response in
                    let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                }, failure: { error in
                    print(error)
                }
            )
        }
    }
    
    func getExercises() {
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
            let url = NSURL(string: "http://localhost:4567/api/v1/exercises?key=\(exKey)")
            
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    
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
                                        
                } catch {
                    print(error)
                }
            }
            
            task.resume()
        }
    }
    
    func getSubmissions(exercise: Exercise) {
        
        // first delete any instances of the Submission entity
        let fetchRequest = NSFetchRequest(entityName: "Submission")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try mainContext?.executeRequest(deleteRequest)
        } catch let error as NSError {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
        let url = NSURL(string: "http://localhost:4567/api/v1/exercises/\(exercise.key)/submissions")

        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? NSArray
                    for object in json! {
                        let entity = NSEntityDescription.entityForName("Submission", inManagedObjectContext: self.mainContext!)
                        
                        // insert submission into core data
                        let submission = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.mainContext) as! Submission
                        // map submission data
                        submission.exercise = exercise
                        
                        
//                        // get comments and set the submission they belong to
//                        if let comments = object["comments"] as? NSArray {
//                            for comment in comments {
//                                let comment = comment as! NSDictionary
//                                
//                                // insert each comment into core data
//                                let commentEntity = NSEntityDescription.entityForName("Comment", inManagedObjectContext: self.mainContext!)
//                                let managedComment = NSManagedObject(entity: commentEntity!, insertIntoManagedObjectContext: self.mainContext) as! Comment
//                                managedComment.submission = submission
//                                managedComment.text = comment.valueForKey("body") as? String // or should I use html_body
//                            }
//                        }
                    }
                    
                    do {
                        try self.mainContext!.save()
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
    
    












