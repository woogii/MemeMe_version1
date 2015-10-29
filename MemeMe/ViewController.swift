//
//  ViewController.swift
//  MemeMe
//
//  Created by Hyun on 2015. 10. 19..
//  Copyright © 2015년 wook2. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
    UITextFieldDelegate{
    
    @IBOutlet weak var lowerTextField: UITextField!
    @IBOutlet weak var upperTextField: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!

    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSBackgroundColorAttributeName: UIColor .clearColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lowerTextField.defaultTextAttributes = memeTextAttributes
        self.upperTextField.defaultTextAttributes = memeTextAttributes
       
        self.upperTextField.textAlignment = .Center
        self.upperTextField.tag = 0

        
        self.lowerTextField.textAlignment = .Center
        self.lowerTextField.tag = 1
        
        self.upperTextField.delegate = self
        self.lowerTextField.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated:Bool){
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
 

    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        //A sourceType of UIImagePickerControllerSourceTypePhotoLibrary or UIImagePickerControllerSourceTypeSavedPhotosAlbum provides a user interface for choosing among saved pictures and movies.
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        //A sourceType of UIImagePickerControllerSourceTypePhotoLibrary or UIImagePickerControllerSourceTypeSavedPhotosAlbum provides a user interface for choosing among saved pictures and movies.
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //Tells the delegate that the user picked a still image or movie
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //Tells the delegate that the user cancelled the pick operation
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {

        if textField.text == "TOP" || textField.text == "BOTTOM"
        {
            textField.text = ""
            
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // Set preset text if text field is empty. topTextField tag is 0 bottomTextField tag is 1
        if textField.text!.isEmpty && textField.tag == 0 {
            textField.text = "TOP"
        } else if textField.text!.isEmpty && textField.tag == 1{
            textField.text = "BOTTOM"
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification:NSNotification) {
        if( lowerTextField.isFirstResponder()){
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification:NSNotification) {
        if ( lowerTextField.isFirstResponder()) {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
}

