//
//  AddInfoViewController.swift
//  homework2
//
//  Created by Weiqi Wei on 15/9/6.
//  Copyright (c) 2015年 Weiqi Wei. All rights reserved.
//

import UIKit

var count: Int = 2

class AddInfoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate  {
    var newStudent = StudentInfo()
    var new_student = newStudentInfo()
    var newPhotoName = String()
    var imageData2 = NSData()
    
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var sexSelection: UISegmentedControl!
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var countryText: UITextField!
    @IBOutlet weak var degreeText: UITextField!
    @IBOutlet weak var language1: UITextField!
    @IBOutlet weak var language2: UITextField!
    @IBOutlet weak var interest1: UITextField!
    @IBOutlet weak var interest2: UITextField!
    @IBOutlet weak var groupText: UITextField!
    //@IBOutlet weak var emailText: UITextField!
    
    
    
    
    @IBAction func addPhoto(sender: AnyObject) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func RotatePicture(sender: AnyObject) {
        imageView.image = imageView.image?.imageRotationByDegrees(90)
        if(newPhotoName != "0.jpg" && newPhotoName != "1.jpg"){
            newPhotoName = "100.png"
        }
    }
    
    @IBAction func takePicture(sender: AnyObject) {
        if SimulatorUtility.isRunningSimulator {
            let alertMessage = UIAlertController(title: "Alert", message: "Camera cannot be used in simulator.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertMessage.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) in
                print("Handle Ok logic here")
            }))
            
            presentViewController(alertMessage, animated: true, completion: nil)
            return
        }
        else {
            imagePicker.sourceType =  UIImagePickerControllerSourceType.Camera
        }
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        newPhotoName = "100.png"
    }
    
    func saveImage(image: UIImage){
        imageData2 = NSData(data:UIImagePNGRepresentation(image)!)
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let docs: String = paths[0]
        let fullPath = (docs as NSString).stringByAppendingPathComponent("\(count).png")
        _ = imageData2.writeToFile(fullPath, atomically: true)
        newPhotoName = "\(count).png"
        count++;
        print(fullPath)
    }
    
    @IBAction func changeSegment(sender: AnyObject) {
        let selectedPicture = sender.selectedSegmentIndex
        if(selectedPicture == 1 && newPhotoName == "0.jpg"){
            let imageName = "1.jpg"
            imageView.image = UIImage(named: imageName)
            newPhotoName = imageName
        }
        else if(selectedPicture == 0 && newPhotoName == "1.jpg"){
            let imageName = "0.jpg"
            imageView.image = UIImage(named: imageName)
            newPhotoName = imageName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        newPhotoName = "0.jpg"
        let imageData = NSData(data:UIImagePNGRepresentation(imageView.image!)!)
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let docs: String = paths[0] 
        let fullPath = (docs as NSString).stringByAppendingPathComponent("\(0).jpg")
        _ = imageData.writeToFile(fullPath, atomically: true)
        
        print(fullPath)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("DismissKeyboard:"))
        view.addGestureRecognizer(tap)
    }
    
    func DismissKeyboard(recognizer: UITapGestureRecognizer){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        nameText.resignFirstResponder()
        countryText.resignFirstResponder()
        degreeText.resignFirstResponder()
        language1.resignFirstResponder()
        language2.resignFirstResponder()
        interest1.resignFirstResponder()
        interest2.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier ==  "ReceiveSegue") {
            return
        }
        if((sender as! UIBarButtonItem) == self.cancelButton){
            return
        }
        else if((sender as! UIBarButtonItem) == self.saveButton){
            saveImage(imageView.image!)
            let interest = (interest1.text)! + " and " + interest2.text!
            var sex: String = "Male"
            if(sexSelection.selectedSegmentIndex == 1){
                sex = "Female"
            }
            newStudent = StudentInfo(Name: nameText.text!, Gender: sex, Country: countryText.text!, Department: degreeText.text!, Programming_languages: (language1.text! + " and " + language2.text!), Interests: interest, photoName: newPhotoName, EMAIL: "")
            new_student = newStudentInfo(Name: nameText.text!, Gender: sex, Country: "from " + countryText.text!, Department: degreeText.text!, Programming_languages: (language1.text! + " and " + language2.text!), Interests: interest, PhotoData: imageData2, EMAIL: "", Group: groupText.text!);
        }
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.registerForKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        //self.deregisterFromKeyboardNotifications()
        
    }
    func findPosition(str:String)->Int{
        let arr = Array(str.characters)
        var pos:Int = 0
        for item in arr{
            if(item == " "){
                return pos
            }
            pos++
        }
        return pos;
    }
    @IBAction func unwindFromReceive(segue: UIStoryboardSegue){
        let source: CentralViewController = segue.sourceViewController as! CentralViewController
        let ReceiveStudent: newStudentInfo = source.student
        
        if(ReceiveStudent.name != ""){
            nameText.text = ReceiveStudent.name
            countryText.text = ReceiveStudent.country_or_state
            degreeText.text = ReceiveStudent.department
            ReceiveStudent.completed = false
            //emailText.text = ReceiveStudent.email
            let recv_interest = ReceiveStudent.interests
            let index1 = findPosition(recv_interest)
            let recv_interest1 = (recv_interest as NSString).substringToIndex(index1)
            let recv_interest2 = (recv_interest as NSString).substringFromIndex(index1 + 5)
            interest1.text = recv_interest1
            interest2.text = recv_interest2
            
            let recv_language = ReceiveStudent.programming_language
            let index2 = findPosition(recv_language)
            let recv_language1 = (recv_language as NSString).substringToIndex(index2)
            let recv_language2 = (recv_language as NSString).substringFromIndex(index2 + 5)
            language1.text = recv_language1
            language2.text = recv_language2
            
            imageView.image = UIImage(data: ReceiveStudent.photodata)
            if(ReceiveStudent.gender == "Male"){
                sexSelection.selectedSegmentIndex = 0
            }
            else{
                sexSelection.selectedSegmentIndex = 1
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
