//
//  SignUp.swift
//  Gallery
//
//  Created by Akash Ungarala on 10/10/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import UIKit
import Firebase

class SignUp: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    var activityIndicatorView: ActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstName.delegate = self
        lastName.delegate = self
        email.delegate = self
        password.delegate = self
        confirmPassword.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func Submit(sender: UIButton) {
        if firstName.text == "" {
            alert("Please enter the First Name")
        } else if email.text == "" {
            alert("Please enter the Email")
        } else if password.text == "" {
            alert("Please enter the Password")
        } else if confirmPassword.text == "" {
            alert("Please enter the Confirmation Password")
        } else if (password.text! != confirmPassword.text!) {
            alert("Confirmation Password doesn't match with Password")
        } else {
            self.activityIndicatorView = ActivityIndicatorView(title: "Signing Up...", center: self.view.center)
            self.view.addSubview(self.activityIndicatorView.getViewActivityIndicator())
            self.activityIndicatorView.startAnimating()
            FIRAuth.auth()!.createUserWithEmail(self.email.text!, password: self.password.text!, completion: { (user, error) in
                if error != nil {
                    self.activityIndicatorView.stopAnimating()
                    self.alert("Firebase Sign Up Error")
                } else {
                    FIRAuth.auth()!.signInWithEmail(self.email.text!, password: self.password.text!, completion: { (user, error) in
                        if error != nil {
                            self.activityIndicatorView.stopAnimating()
                            self.alert("Firebase Login Error")
                        } else {
                            let userId = user?.uid
                            var userInfo = ["id": userId!, "email": self.email.text!, "firstName": self.firstName.text!, "createdAt": FIRServerValue.timestamp(), "updatedAt": FIRServerValue.timestamp()]
                            if self.lastName.text! != "" {
                                userInfo = ["id": userId!, "email": self.email.text!, "firstName": self.firstName.text!, "lastName": self.lastName.text!, "createdAt": FIRServerValue.timestamp(), "updatedAt": FIRServerValue.timestamp()]
                            }
                            FIRDatabase.database().referenceWithPath("users/").child(userId!).setValue(userInfo)
                            self.activityIndicatorView.stopAnimating()
                            self.performSegueWithIdentifier("GallerySegueFromSignUp", sender: sender)
                        }
                    })
                }
            })
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "GallerySegueFromSignUp" {
            return false
        }
        return true
    }
    
    func alert(alertMessage: String) {
        let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}