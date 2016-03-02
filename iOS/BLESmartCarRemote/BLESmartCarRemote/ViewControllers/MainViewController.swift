//
//  MainViewController.swift
//  BLE Smart Car Remote
//
//  Created by Rakesh TA on 11/02/2016.
//  Copyright © 2016 Raptor Soft. All rights reserved.
//

import UIKit
import BLESerial
import CAJoystick


class MainViewController: UIViewController {

    // MARK: - IB Outlets

    @IBOutlet private weak var joystickControl:        CAJoystickControl!
    
    @IBOutlet private weak var speedSetLeftLabel:      UILabel!
    @IBOutlet private weak var speedSetRightLabel:     UILabel!
    @IBOutlet private weak var speedActualLeftLabel:   UILabel!
    @IBOutlet private weak var speedActualRightLabel:  UILabel!
}


// MARK: - View Lifecycle

extension MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize UI
        speedSetLeftLabel.text     = "0"
        speedSetRightLabel.text    = "0"
        speedActualLeftLabel.text  = "-"
        speedActualRightLabel.text = "-"
        
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
    
    @IBAction private func joystickControl_valueChanged(sender: CAJoystickControl) {
        let m  = sender.value.magnitude
        let sl = Int16(m * 255)
        let sr = Int16(m * 255)
        
        speedSetLeftLabel.text  = "\(sl)"
        speedSetRightLabel.text = "\(sr)"
    }
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
