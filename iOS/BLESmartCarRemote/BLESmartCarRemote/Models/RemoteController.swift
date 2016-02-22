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

protocol RemoteControllerDelegate: AnyObject {
    func remoteController(remoteController: RemoteController, didSetConnectedPeripheral peripheral: BLESerialPeripheral?)
}


// MARK: - RemoteController

internal final class RemoteController: NSObject {
    
    
    // MARK: - Singleton
    
    static let sharedController      = RemoteController()
    
    
    // MARK: - Members
    
    let serialManager                = BLESerialManager(restoreIdentifier: nil)
    
    var connectedPeripheral:           BLESerialPeripheral? {
        didSet {
            delegate?.remoteController(self, didSetConnectedPeripheral: connectedPeripheral)
        }
    }
    
    
    // MARK: -
    
    weak var delegate:                 RemoteControllerDelegate?
}