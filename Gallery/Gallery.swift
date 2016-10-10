//
//  Gallery.swift
//  Gallery
//
//  Created by Akash Ungarala on 10/10/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class Gallery: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let ref = FIRDatabase.database().referenceWithPath("users/").child((FIRAuth.auth()?.currentUser?.uid)!).child("gallery")
    var gallery = [NSURL]()
    var ids = [String]()
    var activityIndicatorView: ActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var localArray = [NSURL]()
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            let id = snapshot.value?.objectForKey("id") as! String
            let url = snapshot.value?.objectForKey("url") as! String
            if let imageURL: NSURL? = NSURL(string: url) {
                if let url = imageURL {
                    localArray.insert(url, atIndex: 0)
                    self.ids.insert(id, atIndex: 0)
                }
            }
            self.gallery = localArray
            self.collectionView!.reloadData()
        })
    }
    
    @IBAction func addPhoto(sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var selectedImage: UIImage!
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = originalImage
        }
        dismissViewControllerAnimated(true, completion: nil)
        self.activityIndicatorView = ActivityIndicatorView(title: "Loading...", center: self.view.center)
        self.view.addSubview(self.activityIndicatorView.getViewActivityIndicator())
        self.activityIndicatorView.startAnimating()
        if let image = selectedImage {
            let imageName = NSUUID().UUIDString
            let storageRef = FIRStorage.storage().reference().child("gallery").child("\(imageName).png")
            let uploadData = UIImagePNGRepresentation(image)
            storageRef.putData(uploadData!, metadata: nil, completion: { (metadata, error) in
                if (error == nil) {
                    if let image = metadata?.downloadURL()?.absoluteString {
                        let id = self.ref.childByAutoId().key
                        self.ref.child("\(id)").setValue(["id": id, "url": image])
                        if let imageURL: NSURL? = NSURL(string: image) {
                            if let url = imageURL {
                                self.gallery.insert(url, atIndex: 0)
                                self.ids.insert(id, atIndex: 0)
                            }
                        }
                    }
                }
            })
        }
        self.activityIndicatorView.stopAnimating()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! GalleryCell
        cell.photo.sd_setImageWithURL(gallery[indexPath.row])
        cell.tag = indexPath.row
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PhotoSegue" {
            let destination = segue.destinationViewController as! Photo
            destination.url = gallery[(sender!.tag)!]
            destination.ref = ref.child(ids[sender!.tag])
        }
    }
    
    @IBAction func backToGallery(sender: UIStoryboardSegue) {}

}