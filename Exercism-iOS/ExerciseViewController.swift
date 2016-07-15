//
//  ExerciseViewController.swift
//  Exercism-iOS
//
//  Created by Hom, Kenneth on 4/11/16.
//  Copyright © 2016 Hom, Kenneth. All rights reserved.
//

import UIKit
import CoreData

class ExerciseViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var exercise: Exercise?
    var networkHandler: NetworkHandler?
    lazy var submissionViewControllers = [UIViewController]()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dataSource = self
        
        // self.navigationItem.title = exercise!.name
        self.view.backgroundColor = UIColor.grayColor()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        createSubmissionViews()
    }
    
    private func createSubmissionViews() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Submission")
        
        do {
            let submissions = try managedContext.executeFetchRequest(fetchRequest) as! [Submission]
            print("total submission count: \(submissions.count)")
            
            for submission in submissions {
                let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SubmissionViewController") as! SubmissionViewController
                controller.submission = submission
                submissionViewControllers.append(controller)
            }
            
            if let firstViewController = submissionViewControllers.first {
                setViewControllers([firstViewController], direction: .Forward, animated: true, completion: nil)
            }

        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    
    // MARK: Conform to UIPageViewControllerDataSource
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = submissionViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard submissionViewControllers.count > previousIndex else {
            return nil
        }
        
        return submissionViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = submissionViewControllers.indexOf(viewController) else {
                return nil
            }
            
            let nextIndex = viewControllerIndex + 1
            let submissionViewControllersCount = submissionViewControllers.count
            
            guard submissionViewControllersCount != nextIndex else {
                return nil
            }
            
            guard submissionViewControllersCount > nextIndex else {
                return nil
            }
            
            return submissionViewControllers[nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return submissionViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            firstViewControllerIndex = submissionViewControllers.indexOf(firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    	

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
