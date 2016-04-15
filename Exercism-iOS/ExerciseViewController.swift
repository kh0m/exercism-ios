//
//  ExerciseViewController.swift
//  Exercism-iOS
//
//  Created by Hom, Kenneth on 4/11/16.
//  Copyright © 2016 Hom, Kenneth. All rights reserved.
//

import UIKit

class ExerciseViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    lazy var exercise = Exercise()
    lazy var iterationViewControllers = [UIViewController]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dataSource = self
        
        self.navigationItem.title = exercise.name
        self.view.backgroundColor = UIColor(red: 0.85, green: 0.11, blue: 0.31, alpha: 1.0)
        
        NetworkHandler.getSubmissionKey(exercise)
        
        for _ in (0..<3) {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("IterationViewController") as! IterationViewController
            iterationViewControllers.append(vc)
        }
        
        if let firstViewController = iterationViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .Forward,
                               animated: true,
                               completion: nil)
        }
        
//        for iteration in iterations {
//            let vc = IterationViewController()
//            iterationViewControllers.append(vc)
//        }
        
    }
    
    
    // MARK: Conform to UIPageViewControllerDataSource
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = iterationViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard iterationViewControllers.count > previousIndex else {
            return nil
        }
        
        return iterationViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = iterationViewControllers.indexOf(viewController) else {
                return nil
            }
            
            let nextIndex = viewControllerIndex + 1
            let iterationViewControllersCount = iterationViewControllers.count
            
            guard iterationViewControllersCount != nextIndex else {
                return nil
            }
            
            guard iterationViewControllersCount > nextIndex else {
                return nil
            }
            
            return iterationViewControllers[nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return iterationViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            firstViewControllerIndex = iterationViewControllers.indexOf(firstViewController) else {
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
