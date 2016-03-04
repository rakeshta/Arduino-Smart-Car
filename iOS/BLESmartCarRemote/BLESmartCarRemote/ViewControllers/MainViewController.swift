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
    
    
    // MARK: - Members
    
    private var smartCar: SmartCar? {
        didSet {
            title = smartCar?.serialPeripheral.name ?? "Not Connected"
        }
    }
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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Start scanning if no connected peripheral
        if  smartCar == nil {
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


// MARK: - Segue

extension MainViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        // Attach self as delegate to scan manager
        if  let viewController = segue.destinationViewController as? ScanViewController {
            viewController.delegate = self
        }
    }
}


// MARK: - Actions

extension MainViewController {
    
    @IBAction private func joystickControl_valueChanged(sender: CAJoystickControl) {
        let m  = sender.value.magnitude
        let sl = Int16(m * 255)
        let sr = Int16(m * 255)
        
        // Send command to device
        smartCar?.setSpeed(left: sl, right: sr)
        
        // Show set speed in UI
        speedSetLeftLabel.text  = "\(sl)"
        speedSetRightLabel.text = "\(sr)"
    }
}


// MARK: - Scan View Controller Delegate

extension MainViewController: ScanViewControllerDelegate {
    
    func scanViewController(viewController: ScanViewController, didConnectToPeripheral peripheral: BLESerialPeripheral) {
        smartCar = SmartCar(serialPeripheral: peripheral)
    }
}
