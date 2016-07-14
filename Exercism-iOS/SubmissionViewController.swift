//
//  SubmissionViewController.swift
//  Exercism-iOS
//
//  Created by Hom, Kenneth on 4/11/16.
//  Copyright © 2016 Hom, Kenneth. All rights reserved.
//

import UIKit

class SubmissionViewController: UIViewController {
    
    var submission: Submission?

    @IBOutlet weak var submissionCodeView: UITextView!
    
    @IBOutlet weak var commentsScrollView: UIScrollView!

    @IBOutlet weak var commentView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // code view
        submissionCodeView.text = "yolo"
        
        // make comment views for the submission
        for comment in submission!.comments! {
            if let commentText = comment.valueForKey("text") as? String {
                commentView.text = commentText
            }
        }
        

        
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
