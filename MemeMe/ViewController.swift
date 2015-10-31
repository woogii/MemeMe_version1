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
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    var memedImage:UIImage!
    
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),              // describe outline color
        NSForegroundColorAttributeName : UIColor.whiteColor(),          // specify the color of the text
        NSBackgroundColorAttributeName: UIColor .clearColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0                              // specify negative values to stroke and fill the text
    ]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set default attribute of input text
        self.lowerTextField.defaultTextAttributes = memeTextAttributes
        self.upperTextField.defaultTextAttributes = memeTextAttributes
       
        self.upperTextField.textAlignment = .Center
        self.upperTextField.tag = 0

        self.lowerTextField.textAlignment = .Center
        self.lowerTextField.tag = 1
        
        self.upperTextField.delegate = self
        self.lowerTextField.delegate = self
        
        shareButton.enabled = false
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated:Bool){
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
 
    func save() {
        //create the meme object
        let meme = Meme( bottomText: lowerTextField.text!,
            topText: upperTextField.text!,
            originalImage:imagePickerView.image!,
            inputMemed: self.memedImage)
    }
    
    func generateMemedImage() -> UIImage
    {
        
        // hide toolbar and navbar to avoid shown in the rendered image
        navBar.hidden = true
        toolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        // show toolbar and navbar
        navBar.hidden = false
        toolBar.hidden = false
        
        return memedImage
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        // check whether source is from camera or photo library
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        // check whether source is from camera or photo library
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
 
    @IBAction func shareMeme(sender: AnyObject) {
        self.memedImage = generateMemedImage()          // generate a memed image
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
        // completionWithItemsHandler let application know the final result of the operation
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            print("Activity: \(activity) Success: \(success) Items: \(items) Error: \(error)")
            
            if(success) {       // if activityviewcontroller perform successfully
                self.save()     // save a memed image
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }

    }
    
    // tells the delegate that the user picked a still image or movie
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerView.image = image
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
        cancelButton.enabled = false
    }
    
    // tells the delegate that the user cancelled the pick operation
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // share button can be enabled only if there is a modified image
        if imagePickerView.image != nil {
            shareButton.enabled = true
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // clear the text if it is not a default text, "TOP" or "BOTTOM"
        if textField.text == "TOP" || textField.text == "BOTTOM"
        {
            textField.text = ""
            
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // set preset text if text field is empty. topTextField tag is 0 bottomTextField tag is 1
        if textField.text!.isEmpty && textField.tag == 0 {
            textField.text = "TOP"
        } else if textField.text!.isEmpty && textField.tag == 1{
            textField.text = "BOTTOM"
        }
    
    }
    
    func subscribeToKeyboardNotifications() {
        // notification posted immediately prior to the display of the keyboard
        NSNotificationCenter .defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        // notification posted immediately prior to the dismissal of the keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        // remove all observers from self
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
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
    
    // calculate the height of the Keyboard
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
}

