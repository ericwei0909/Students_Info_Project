//
//  DetailViewController.swift
//  homework4
//
//  Created by Weiqi Wei on 15/9/20.
//  Copyright (c) 2015年 Physaologists. All rights reserved.
//

import UIKit
import MessageUI
import CoreBluetooth

var group11 = [Int]()
var name_to_rating:[String: Float] = ["Weiqi Wei":0, "Hao Li":0, "Emmanuel Shiferaw":0]

class DetailViewController: UIViewController, MFMailComposeViewControllerDelegate, CBPeripheralManagerDelegate, UITextViewDelegate {
    
    var requestedStudentInfo = newStudentInfo(Name: "Deyu Jiao")
    
    let flipSegueIdentifier = "FlipSegue"

    @IBOutlet weak var detailDescriptionLabel: UILabel!    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var flipToDrawing: UIBarButtonItem!
    
    // peripheral
    @IBOutlet weak var advertisingSwitch: UISwitch!
    
    var peripheralManager:CBPeripheralManager!
    var transferCharacteristic:CBMutableCharacteristic!

    var sendDataIndex:Int = 0
    var sendingEOM:Bool = false
    var InfoToSend: newStudentInfo = newStudentInfo()
    var dataToSend: NSData! // 1 send
    
    
    var sendBackInfo = String()
    
    var comming_string: String?
    
    var interestFileName = ""
    
    var myRating: Float = Float()
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
        
    }

    override func viewWillDisappear(animated: Bool) {
        self.peripheralManager.stopAdvertising()
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {   // MAKR: get prepared to show information of certain student
        let student = requestedStudentInfo
        /*-----------------------------------------------------*/
        
        InfoToSend = newStudentInfo(Name: student.name, Gender: student.gender, Country: student.country_or_state, Department: student.department, Programming_languages: student.programming_language, Interests: student.interests, PhotoData: student.photodata, EMAIL:student.email, Group: student.group)
        
        /*-------------------------------------------------------------*/
        
        detailDescriptionLabel.numberOfLines = 10
        let (text, _) = student.get_all_info()
        detailDescriptionLabel.text = text
        
        if(requestedStudentInfo.name == "Weiqi Wei" || requestedStudentInfo.name == "Hao Li" || requestedStudentInfo.name == "Emmanuel Shiferaw"){
            flipToDrawing.enabled = true
        }
        else{
            flipToDrawing.enabled = false
        }
 
        let next_image = UIImage(data: student.photodata)
        imageView.image = next_image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == flipSegueIdentifier {           // MARK: it will go to the DrawingViewController
            let destination = (segue.destinationViewController as! UINavigationController).topViewController as! DrawingViewController
            
            interestFileName = "plane.png"
            destination.myRating = name_to_rating[requestedStudentInfo.name]!
            
            destination.userPhoto = UIImage(named: interestFileName)!
            destination.myName = requestedStudentInfo.name;
            
            
        }
        else if segue.identifier == "editSegueIdentifier" {     // MARK: it will go to the EditViewController
            let destination = (segue.destinationViewController as! UINavigationController).topViewController as! EditViewController
            destination.student = requestedStudentInfo
        }
        
        else {
            print("Why wouldn't the segue work")
        }
    }
    
    @IBAction func unwindToStudent(segue: UIStoryboardSegue) {   //MARK: go back from DrawingViewController and save rating data
        let source: DrawingViewController = segue.sourceViewController as! DrawingViewController
        myRating = source.myRating
        
        if(requestedStudentInfo.name == "Emmanuel Shiferaw"){
            name_to_rating["Emmanuel Shiferaw"] = source.myRating
        }
        else if(requestedStudentInfo.name == "Weiqi Wei"){
            name_to_rating["Weiqi Wei"] = source.myRating
        }
        else if(requestedStudentInfo.name == "Hao Li"){
            name_to_rating["Hao Li"] = source.myRating
        }
        print("\(myRating)")
    }

        
        // MARK: - Peripheral Methods
        
        func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
            if (peripheral.state != CBPeripheralManagerState.PoweredOn) {
                return
            }
            else {
                print("powered on and ready to go")
                // This is an example of a Notify Characteristic for a Readable value
                transferCharacteristic = CBMutableCharacteristic(type:
                    characteristicUUID, properties: CBCharacteristicProperties.Notify, value: nil, permissions: CBAttributePermissions.Readable)
                // This sets up the Service we will use, loads the Characteristic and then adds the Service to the Manager so we can start advertising
                let transferService = CBMutableService(type: serviceUUID, primary: true)
                transferService.characteristics = [self.transferCharacteristic]
                self.peripheralManager.addService(transferService)
                
            }
        }
        
        func peripheralManager(peripheral: CBPeripheralManager, central: CBCentral, didSubscribeToCharacteristic characteristic: CBCharacteristic) {
            print("data request connection coming in")
            // A subscriber was found, so send them the data
            // 2 define the data to be sent !
            self.dataToSend = NSKeyedArchiver.archivedDataWithRootObject(InfoToSend)
            self.sendDataIndex = 0
            self.sendData()
        }
        
        func peripheralManager(peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFromCharacteristic characteristic: CBCharacteristic) {
            print("unsubscribed")
        }
        // 2 send !
        func sendData() {
            if (sendingEOM) {                // MARK: sending the end of message indicator
                let didSend:Bool = self.peripheralManager.updateValue(endOfMessage!, forCharacteristic: self.transferCharacteristic, onSubscribedCentrals: nil)
                if (didSend) {
                    sendingEOM = false
                    print("sent EOM, outer loop")
                }
                else {
                    return
                }
            }
            else {                          // MARK: sending the payload
                if (self.sendDataIndex >= self.dataToSend.length) {
                    return
                }
                else {
                    var didSend:Bool = true
                    while (didSend) {
                        var amountToSend = self.dataToSend.length - self.sendDataIndex
                        if (amountToSend > MTU) {
                            amountToSend = MTU
                        }
                        let chunk = NSData(bytes: self.dataToSend.bytes+self.sendDataIndex, length: amountToSend)
                        didSend = self.peripheralManager.updateValue(chunk, forCharacteristic: self.transferCharacteristic, onSubscribedCentrals: nil)
                        if (!didSend) {
                            return
                        }
                        print("Sent ",NSString(data: chunk, encoding: NSUTF8StringEncoding))
                        self.sendDataIndex += amountToSend
                        if (self.sendDataIndex >= self.dataToSend.length) {
                            sendingEOM = true
                            let eomSent:Bool = self.peripheralManager.updateValue(endOfMessage!, forCharacteristic: self.transferCharacteristic, onSubscribedCentrals: nil)
                            if (eomSent) {
                                sendingEOM = false
                                print("send EOM, inner loop")
                            }
                            return
                        }
                    }
                }
            }
        }
        
        func peripheralManagerIsReadyToUpdateSubscribers(peripheral: CBPeripheralManager) {
            self.sendData()
        }
    
    @IBAction func Switch_Changed(sender: AnyObject) {
        if (self.advertisingSwitch.on) {
            print("go into switch function")
            let dataToBeAdvertised: [String:AnyObject!] = [
                CBAdvertisementDataServiceUUIDsKey : serviceUUIDs ]
            self.peripheralManager.startAdvertising(dataToBeAdvertised)
        }
        else {
            self.peripheralManager.stopAdvertising()
        }
    }
    
}
