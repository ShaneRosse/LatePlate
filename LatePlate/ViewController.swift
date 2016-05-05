//
//  ViewController.swift
//  LatePlate
//
//  Created by Shane Rosse on 4/8/16.
//  Copyright © 2016 Shane Rosse. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

class ViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet weak var entreeLabel: UILabel!
    @IBOutlet weak var sideOneLabel: UILabel!
    @IBOutlet weak var sideTwoLabel: UILabel!
    @IBOutlet weak var saladLabel: UILabel!
    @IBOutlet weak var extraLabel: UILabel!
    @IBOutlet weak var whiteBoardView: UIView!
    
    let db_url: String = "https://blazing-heat-9345.firebaseio.com"
    var userFBName: String! = ""
    
    var menu: [String]!
    
    func fillTextField() {
        if FBSDKAccessToken.currentAccessToken() != nil {
            FBSDKGraphRequest.init(graphPath: "me", parameters:["fields": "name"] ).startWithCompletionHandler({ (fbconn, result, err) in
                if err == nil {
                    print("Here... \(result)")
                    let info: Dictionary<String, AnyObject>! = result as? Dictionary
                    let fbName: String! = info["name"] as? String
                    self.nameField.text = fbName
                    let appD: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appD.userFBName = fbName
                }
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        fillTextField()
        signupButton.layer.cornerRadius = 10
    }
    
    func updateLabels() {
        let count = menu.count
        if count > 0 {
            print(menu[0])
            entreeLabel.text = menu[0]
        }
        if count > 1 {
            print(menu[1])
            sideOneLabel.text = menu[1]
        }
        if count > 2 {
            print(menu[2])
            sideTwoLabel.text = menu[2]
        }
        if count > 3 {
            print(menu[3])
            saladLabel.text = menu[3]
        }
        if count > 4 {
            print(menu[4])
            extraLabel.text = menu[4]
        }
    }
    
    func startUp() {
        let db_menu: String = "prod/menu"
        let ref = Firebase(url: db_url)
        let myMenuRef = ref.childByAppendingPath(db_menu)
        
        myMenuRef.observeEventType(.Value, withBlock: { snapshot in
            if (snapshot.value == nil) {
                print("No value from Firebase")
            } else {
                self.menu = snapshot.value as? [String]
                self.updateLabels()
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        whiteBoardView.layer.cornerRadius = 10
        startUp()
        // Do any additional setup after loading the view, typically from a nib.
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.backgroundView.addGestureRecognizer(tapGesture)
    }
    
    func dismissKeyboard() {
        nameField.resignFirstResponder()
        checkTime()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkTime() -> Bool {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        
        print(hour)
        print(minutes)
        
        if ((hour >= 16 && minutes >= 30) || (hour >= 17)) && (hour <= 21) {
            return true
        } else {
            return false
        }
    }
    
    func notifyTooLate() {
        let message: String = "Warning! It's past 4:30pm. Do you want to sign up for tomorrow's dinner?"
        let alertController = UIAlertController(title: "Late Plate", message: message, preferredStyle: .ActionSheet)
        
        let okAction = UIAlertAction(title: "YES", style: .Default, handler: { (UIAlertAction) in
            self.sendUpPlate()
        })
        
        let noAction = UIAlertAction(title: "NO", style: .Default) { (UIAlertAction) in
            //
        }
        
        alertController.addAction(okAction)
        alertController.addAction(noAction)
        self.presentViewController(alertController, animated: true, completion: {
            
        })
    }
    
    @IBAction func signupTouch(sender: AnyObject) {
        if checkTime() {
            self.notifyTooLate()
        } else {
            sendUpPlate()
        }
    }
    
    func sendUpPlate() {
        let myRootRef = Firebase(url: db_url)
        let myUserRef = myRootRef.childByAppendingPath("prod/users")
        
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

