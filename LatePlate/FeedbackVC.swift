//
//  FeedbackVC.swift
//  LatePlate
//
//  Created by Shane Rosse on 5/3/16.
//  Copyright © 2016 Shane Rosse. All rights reserved.
//

import UIKit
import HMWDStarRatingView
import Firebase
import FBSDKCoreKit

class FeedbackVC: UIViewController, WDStarRatingDelegate {

    @IBOutlet weak var starReview: WDStarRatingView!
    @IBOutlet weak var reviewField: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    let db_base: String = "https://blazing-heat-9345.firebaseio.com"

    override func viewDidLoad() {
        super.viewDidLoad()
        starReview.delegate = self
        // Do any additional setup after loading the view.
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(animated: Bool) {
        submitButton.layer.cornerRadius = 10
    }
    
    func getTodayDate() -> String {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: date)
        let year = components.year
        let month = components.month
        let day = components.day
        let datestring: String = "\(year)-\(month)-\(day)"
        return datestring
    }
    
    @IBAction func submitTouch(sender: AnyObject) {
        
        let myRootRef = Firebase(url: db_base)
        let myFeedbackRef = myRootRef.childByAppendingPath("prod/feedback")
        
        if let review = reviewField.text {
            // date it
            let datedRef = myFeedbackRef.childByAppendingPath(getTodayDate())
            let uniqueRef = datedRef.childByAutoId()
            // send up a list of name, star number, review
            let star_float: AnyObject = starReview.value
            let star_str: String = String(star_float)
            let appD: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let name: String = appD.userFBName!
            let reviewData: Array<String> = Array<String>(arrayLiteral: name, star_str, review)
            uniqueRef.setValue(reviewData, withCompletionBlock: { (error, firebase) in
                var message: String = ""
                if (error != nil) {
                    message = "Something went wrong in our database..."
                    print("This is the Firebase error: \(error)")
                } else {
                    message = "Thank you!"
                }
                let alertController = UIAlertController(title: "Late Plate", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "Dismiss", style: .Default, handler: { (UIAlertAction) in
                    self.dismissKeyboard()
                })
                
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: {
                    
                })
            })
        }
    }
    
    func dismissKeyboard() {
        reviewField.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func starRatingView(starRatingView: WDStarRatingView, didDrawStarsWithValue value: CGFloat) {
        print("didDraw")
    }
    
    func starRatingView(starRatingView: WDStarRatingView, didUpdateToValue value: CGFloat) {
        print("didUpdate")
    }
    
    func starRatingView(starRatingView: WDStarRatingView, didStartTracking tracking: Bool) {
        print("didStart")
    }
    
    func starRatingView(starRatingView: WDStarRatingView, didStopTracking tracking: Bool) {
        print("didStop")
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
