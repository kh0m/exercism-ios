//
//  IterationsRequest.swift
//  Exercism-iOS
//
//  Created by Hom, Kenneth on 4/29/16.
//  Copyright © 2016 Hom, Kenneth. All rights reserved.
//

import UIKit
import CoreData

class IterationsRequest: NSOperation {
    var context: NSManagedObjectContext?
    
    private var innerContext: NSManagedObjectContext?
    private var task: NSURLSessionTask?
    private let incomingData = NSMutableData()
    
    private var exercise: Exercise?
    
    init(ex: Exercise) {
        super.init()
        //set some parameters here
        self.exercise = ex
    }
    
    var internalFinished: Bool = false
    override var finished: Bool {
        get {
            return internalFinished
        }
        set (newAnswer) {
            willChangeValueForKey("isFinished")
            internalFinished = newAnswer
            didChangeValueForKey("isFinished")
        }
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask,
                    didReceiveResponse response: NSURLResponse,
                                       completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        if cancelled {
            finished = true
            task?.cancel()
            return
        }
        //Check the response code and react appropriately
        completionHandler(.Allow)
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask,
                    didReceiveData data: NSData) {
        if cancelled {
            finished = true
            task?.cancel()
            return
        }
        incomingData.appendData(data)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask,
                    didCompleteWithError error: NSError?) {
        if cancelled {
            finished = true
            task.cancel()
            return
        }
        if error != nil {
            print("Failed to receive response: \(error)")
            finished = true
            return
        }
        
        //PROCESS DATA INTO CORE DATA
        
        // first delete any instances of the Iteration entity
        let fetchRequest = NSFetchRequest(entityName: "Iteration")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context?.executeRequest(deleteRequest)
        } catch let error as NSError {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
        if let exKey = Exercism["apiKey"] { // for when we get the real api
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
            
        }

        
        finished = true
    }
}
