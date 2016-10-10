//
//  Login.swift
//  Gallery
//
//  Created by Akash Ungarala on 10/10/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import UIKit
import Firebase

class Login: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var activityIndicatorView: ActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (FIRAuth.auth()?.currentUser != nil) {
            performSegueWithIdentifier("GallerySegueFromLogin", sender: nil)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func Login(sender: UIButton) {
        if email.text == "" {
            alert("Please enter the Email")
        } else if password.text == "" {
            alert("Please enter the Password")
        } else {
            self.activityIndicatorView = ActivityIndicatorView(title: "Signing In...", center: self.view.center)
            self.view.addSubview(self.activityIndicatorView.getViewActivityIndicator())
            self.activityIndicatorView.startAnimating()
            FIRAuth.auth()!.signInWithEmail(self.email.text!, password: self.password.text!, completion: { (user, error) in
                if error != nil {
                    self.activityIndicatorView.stopAnimating()
                    self.alert("Firebase Login Error")
                } else {
                    self.performSegueWithIdentifier("GallerySegueFromLogin", sender: sender)
                    self.activityIndicatorView.stopAnimating()
                }
            })
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "GallerySegueFromLogin" {
            return false
        }
        return true
    }
    
    @IBAction func cancelToLogin(sender: UIStoryboardSegue) {}
    
    @IBAction func submitToLogin(sender: UIStoryboardSegue) {
        performSegueWithIdentifier("GallerySegueFromLogin", sender: nil)
    }
    
    @IBAction func logoutToLogin(sender: UIStoryboardSegue) {
        try! FIRAuth.auth()!.signOut()
    }
    
    func alert(alertMessage: String) {
        let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
