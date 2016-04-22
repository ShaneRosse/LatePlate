//
//  ViewController.swift
//  LatePlate
//
//  Created by Shane Rosse on 4/8/16.
//  Copyright © 2016 Shane Rosse. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    
    let db_url: String = "https://blazing-heat-9345.firebaseio.com"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.backgroundView.addGestureRecognizer(tapGesture)
    }
    
    func dismissKeyboard() {
        nameField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupTouch(sender: AnyObject) {
        
        let myRootRef = Firebase(url: db_url)
        let myUserRef = myRootRef.childByAppendingPath("users")
        
        if let name = nameField.text {
            let uniqueRef = myUserRef.childByAutoId()
            self.dismissKeyboard()
            uniqueRef.setValue(name, withCompletionBlock: { (error, firebase) in
                var message: String = ""
                if (error != nil) {
                    message = "Something went wrong in our database..."
                    print("This is the Firebase error: \(error)")
                } else {
                    message = "You're signed up!"
                }
                let alertController = UIAlertController(title: "Late Plate", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) in
                    self.dismissKeyboard()
                })
                
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: {
                    
                })
            })
        }
        
    }
}

