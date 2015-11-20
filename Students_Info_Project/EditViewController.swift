//
//  EditViewController.swift
//  homework4
//
//  Created by Emmanuel Shiferaw on 2/9/15.
//  Copyright © 2015 Physaologists. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UIScrollViewDelegate {

    var student:newStudentInfo = newStudentInfo()
    
    //MARK: Outlets
    @IBOutlet weak var studentImage: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var degreeField: UITextField!
    @IBOutlet weak var languagesField: UITextField!
    @IBOutlet weak var interestsField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var countryField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("DismissKeyboard:"))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        nameField.text = student.name
        countryField.text = student.country_or_state
        degreeField.text = student.department
        languagesField.text = student.programming_language
        interestsField.text = student.interests
        
        let next_image = UIImage(data: student.photodata)
        studentImage.image = next_image
    
        self.registerForKeyboardNotifications()
    }
    
    
    //MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if((sender as! UIBarButtonItem) == self.cancelButton){
            return
        }
        else{
            student.name = nameField.text!
            student.country_or_state = countryField.text!
            student.department = degreeField.text!
            student.programming_language = languagesField.text!
            student.interests = interestsField.text!
        }
        
    }
    
    func DismissKeyboard(recognizer: UITapGestureRecognizer){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        nameField.resignFirstResponder()
        countryField.resignFirstResponder()
        degreeField.resignFirstResponder()
        languagesField.resignFirstResponder()
        interestsField.resignFirstResponder()
    }
    
    func registerForKeyboardNotifications ()-> Void   {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
        
        
    }
    
    func deregisterFromKeyboardNotifications () -> Void {
        let center:  NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
        center.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
        
    }
    
    
    func keyboardWasShown (notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            if let keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size {
                let contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height,  0.0);
                
                self.scrollView.contentInset = contentInset
                self.scrollView.scrollIndicatorInsets = contentInset
                
                self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, 0 + keyboardSize.height) //set zero instead self.scrollView.contentOffset.y
                
            }
        }
    }
    
    func keyboardWillBeHidden (notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            if let _: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size {
                let contentInset = UIEdgeInsetsZero;
                
                self.scrollView.contentInset = contentInset
                self.scrollView.scrollIndicatorInsets = contentInset
                self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y)
            }
        }
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
