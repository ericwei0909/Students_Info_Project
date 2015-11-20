//
//  CentralViewController.swift
//  Bluetooth
//
//  Created by Ric Telford on 6/30/15.
//  Copyright (c) 2015 Ric Telford. All rights reserved.
//

import UIKit
import CoreBluetooth

class CentralViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    
    @IBOutlet weak var imageShow: UIImageView!  // MARK: display the image received
    
    @IBOutlet weak var infoShow: UILabel!     // MARK: display the information about the student received
    
    var centralManager:CBCentralManager!
    var connectingPeripheral:CBPeripheral!
    
    var data: NSMutableData = NSMutableData()
    
    
    var student: newStudentInfo = newStudentInfo()
    override func viewWillAppear(animated: Bool) {
        infoShow.numberOfLines = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Initializing central manager")
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.centralManager.stopScan()
        print("scanning stopped")
        super.viewWillDisappear(animated)
    }

    
    // MARK:  Central Manager Delegate methods
    func centralManagerDidUpdateState(central: CBCentralManager) {
        print("checking state")
        switch(central.state) {
        case .PoweredOff:
            print("CB BLE hw is powered off")
            
        case .PoweredOn:
            print("CB BLE hw is powered on")
            self.scan()
            
        default:
            return
        }
    }
    
    func scan() {
        self.centralManager.scanForPeripheralsWithServices(serviceUUIDs as? [CBUUID],options: nil)
        print("scanning started\n\n\n")
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        if RSSI.integerValue > -15 {
            return
        }
        print("discovered \(peripheral.name) at \(RSSI)")
        if connectingPeripheral != peripheral {
            connectingPeripheral = peripheral
            connectingPeripheral.delegate = self
            print("connecting to peripheral \(peripheral)")
            centralManager.connectPeripheral(connectingPeripheral, options: nil)
        }
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("failed to connect to \(peripheral) due to error \(error)")
        self.cleanup()
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("\n\nperipheral connected\n\n")
        centralManager.stopScan()
        peripheral.delegate = self as CBPeripheralDelegate
        peripheral.discoverServices(nil)
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        if let _ = error {
            print("error discovering services \(error!.description)")
            self.cleanup()
        }
        else {
            for service in peripheral.services as [CBService]!{
                print("service UUID  \(service.UUID)\n")
                if (service.UUID == serviceUUID) {
                    peripheral.discoverCharacteristics(nil, forService: service)
                }
            }
        }
    }

    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        if let _ = error {
            print("error - \(error!.description)")
            print(error)
            self.cleanup()
        }
        else {
            for characteristic in service.characteristics as [CBCharacteristic]! {
                print("characteristic is \(characteristic)\n")
                if (characteristic.UUID == characteristicUUID) {
                    peripheral.setNotifyValue(true, forCharacteristic: characteristic)
                }
            }
        }
    }
    // MARK: receive the characteristic from peripheral (the student class)
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if let _ = error {
            print("error")
        }
        else {
            let dataString = NSString(data: characteristic.value!, encoding: NSUTF8StringEncoding)
            
            if dataString == "EOM" {  // at the end of the data
                print(self.data)
                // unarchive
                student = NSKeyedUnarchiver.unarchiveObjectWithData(self.data) as! newStudentInfo
                let (result, _) = student.get_all_info()
                // display the information received
                infoShow.text = result
                imageShow.image = UIImage(data: student.photodata)
                
                peripheral.setNotifyValue(false, forCharacteristic: characteristic)
                centralManager.cancelPeripheralConnection(peripheral)
            }
            else {
                self.data.appendData(characteristic.value!)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if let _ = error {
            print("error changing notification state \(error!.description)")
        }
        if (characteristic.UUID != serviceUUID) {
            return
        }
        if (characteristic.isNotifying) {
            print("notification began on \(characteristic)")
        }
        else {
            print("notification stopped on \(characteristic). Disconnecting")
            self.centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("didDisconnect error is \(error)")
    }
    
    func cleanup() {
        
        switch connectingPeripheral.state {
        case .Disconnected:
            print("cleanup called, .Disconnected")
            return
        case .Connected:
            if (connectingPeripheral.services != nil) {
                print("found")
                //add any additional cleanup code here
            }
        default:
            return
        }
    }
    
}