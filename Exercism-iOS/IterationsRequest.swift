//
//  IterationsRequest.swift
//  Exercism-iOS
//
//  Created by Hom, Kenneth on 4/29/16.
//  Copyright © 2016 Hom, Kenneth. All rights reserved.
//

import UIKit
import CoreData

class IterationsRequest: NSOperation, NSURLSessionDelegate {
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
        
        finished = true
    }
}
