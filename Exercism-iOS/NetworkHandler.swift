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
    
    let queue: NSOperationQueue = NSOperationQueue()
    var mainContext: NSManagedObjectContext?
    
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
                    
                } catch {
                    print(error)
                }
            }
            
            task.resume()
        }
    }
    
    func getIterations(exercise: Exercise, completion: Void -> Bool) {
        print(exercise)
        let operation = IterationsRequest(ex: exercise)
        
        
        // first delete any instances of the Iteration entity
        let fetchRequest = NSFetchRequest(entityName: "Iteration")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context?.executeRequest(deleteRequest)
        } catch let error as NSError {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
            let url = NSURL(string: "http://localhost:4567/api/v1/submissions/elixir/acronym/iterations?key=aug949")
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? NSArray
                    for object in json! {
                        
                        let entity = NSEntityDescription.entityForName("Iteration", inManagedObjectContext: self.context!)
                        let iteration = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.context) as! Iteration
                        
                        print("OBJEEEEECT: \(object["submission"]!!["solution"])")
                        let submission = object["submission"]
                        let solution = submission!!["solution"]
                        iteration.code = solution as? String
                        
                        iteration.exercise = self.exercise
                        print("exercise iterations: \(self.exercise!.iterations?.allObjects.count)")
                    }
                    
                } catch {
                    print(error)
                }
                
                do {
                    try self.context!.save()
                } catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            task.resume()
            
        
        operation.URLSession(NSURLSession.sharedSession(), dataTask: <#T##NSURLSessionDataTask#>, didCompleteWithError: error)
        queue.addOperation(operation)
        completion()
    }
    
    

}










