//
//  MainViewController.swift
//  BLE Smart Car Remote
//
//  Created by Rakesh TA on 11/02/2016.
//  Copyright © 2016 Raptor Soft. All rights reserved.
//

import UIKit
import BLESerial


class MainViewController: UIViewController {

    // MARK: - IB Outlets
    
}


// MARK: - View Lifecycle

extension MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Convert to MVP
        RemoteController.sharedController.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Start scanning if no connected peripheral
        if  RemoteController.sharedController.connectedPeripheral == nil {
            performSegueWithIdentifier("ShowScanViewController", sender: nil)
        }
    }
}


// MARK: - Appearance

extension MainViewController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}


// MARK: - Actions

extension MainViewController {
    
}


// MARK: - Text Field Delegate

extension MainViewController: UITextFieldDelegate {

}


// MARK: - TODO: Convert to MVP

extension MainViewController: RemoteControllerDelegate {
    
    func remoteController(remoteController: RemoteController, didSetConnectedPeripheral peripheral: BLESerialPeripheral?) {
        
        // Refresh UI
        if  let peripheral = RemoteController.sharedController.connectedPeripheral {
            title = peripheral.name
        }
        else {
            title = "Not Connected"
        }
    }
}
