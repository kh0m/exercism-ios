//
//  ExercisesTableViewController.swift
//  Exercism-iOS
//
//  Created by Hom, Kenneth on 4/3/16.
//  Copyright © 2016 Hom, Kenneth. All rights reserved.
//

import UIKit
import OAuthSwift
import CoreData

class ExercisesTableViewController: UITableViewController {
    
    lazy var languages = [Language]()
    var networkHandler: NetworkHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        authorize()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        networkHandler = appDelegate.networkHandler
        
        let managedContext = appDelegate.managedObjectContext

        let fetchRequest = NSFetchRequest(entityName: "Language")
        
        do {
            languages = try managedContext.executeFetchRequest(fetchRequest) as! [Language]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return languages.count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return languages[section].name
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let lang = languages[section]
        return lang.exercises!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        // Configure the cell...
        let lang = languages[indexPath.section]
        cell.textLabel?.text = lang.exercises?.allObjects[indexPath.row].name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "toExercise") {
            let destinationController = segue.destinationViewController as! ExerciseViewController
            let path = self.tableView.indexPathForCell(sender as! UITableViewCell)!
            let language = languages[path.section]
            if let exercise = language.valueForKey("exercises")?.allObjects[path.row] as? Exercise {
                // tell networkHandler to getIterations for this exercise and put it into core data
                networkHandler!.getSubmissions(exercise)
                // then when you load the next viewController, pull from core data
                destinationController.exercise = exercise
            }
            destinationController.networkHandler = networkHandler
            
        }
    }
    
    // MARK: - Editing
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
}

extension ExercisesTableViewController {
    func authorize() {
    
        let oauthswift = OAuth2Swift(
            consumerKey:    Github["consumerKey"]!,
            consumerSecret: Github["consumerSecret"]!,
            authorizeUrl:   "https://github.com/login/oauth/authorize",
            accessTokenUrl: "https://github.com/login/oauth/access_token",
            responseType:   "code"
        )
        
        let state: String = generateStateWithLength(20) as String
        
        let loginController = LoginViewController()
        oauthswift.authorize_url_handler = loginController
        
        oauthswift.authorizeWithCallbackURL( NSURL(string: "Exercism-iOS://oauth-callback/github")!, scope: "user,repo", state: state, success: {
            credential, response, parameters in
            
            print("Parameters: \(parameters)")
            Github["accessToken"] = parameters["access_token"]
            self.networkHandler!.getUser(oauthswift)
            self.networkHandler!.getExercises()
            
            loginController.dismissWebViewController()
            
        }, failure: { error in
        print(error.localizedDescription)
        })
        
        
    }

}





