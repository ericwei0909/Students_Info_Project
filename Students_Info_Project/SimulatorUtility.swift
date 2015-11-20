//
//  SimulatorUtility.swift
//  homework4
//
//  Created by Weiqi Wei on 15/9/30.
//  Copyright (c) 2015年 Physaologists. All rights reserved.
//

import Foundation

class SimulatorUtility
{
    class var isRunningSimulator: Bool{          // MARK: determine whether it is in simulator now
        get{
        return TARGET_IPHONE_SIMULATOR != 0
        }
    }
}