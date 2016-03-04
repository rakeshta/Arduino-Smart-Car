//
//  RemoteController.swift
//  BLE Smart Car Remote
//
//  Created by Rakesh TA on 21/02/2016.
//  Copyright © 2016 Raptor Soft. All rights reserved.
//

import Foundation
import BLESerial


// MARK: - RemoteControllerDelegate

protocol RemoteControllerDelegate1: AnyObject {
    func remoteController(remoteController: RemoteController1, didSetConnectedPeripheral peripheral: BLESerialPeripheral?)
}


// MARK: - RemoteController

internal class RemoteController1: NSObject {
    
    
    // MARK: - Singleton
    
    static let sharedController      = RemoteController1()
    
    
    // MARK: - Members
    
    let serialManager                = BLESerialManager(restoreIdentifier: nil)
    
    var connectedPeripheral:           BLESerialPeripheral? {
        didSet {
            delegate?.remoteController(self, didSetConnectedPeripheral: connectedPeripheral)
        }
    }
    
    
    // MARK: -
    
    weak var delegate:                 RemoteControllerDelegate1?
}


// MARK: - Control Messages

extension RemoteController1 {
    
}