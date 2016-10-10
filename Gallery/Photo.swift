//
//  Photo.swift
//  Gallery
//
//  Created by Akash Ungarala on 10/10/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class Photo: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    
    var url: NSURL!
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.sd_setImageWithURL(url)
    }
    
    @IBAction func photoDelete(sender: UIBarButtonItem) {
        let input = UIAlertController(title: "Photo Delete", message: "Do you want to delete this photo?", preferredStyle: UIAlertControllerStyle.Alert)
        input.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: nil))
        input.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            self.ref.setValue(nil)
            self.performSegueWithIdentifier("Back", sender: nil)
        }))
        input.view.setNeedsLayout()
        self.presentViewController(input, animated: true, completion: nil)
    }
    
}