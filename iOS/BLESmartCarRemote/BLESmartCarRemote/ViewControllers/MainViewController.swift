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
            
            // Attach delegate
            smartCar?.delegate = self
            
            // Update title
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
        var viewController = segue.destinationViewController
        
        // Get root view controller if destination is a navigation controller
        if  let navigationController = viewController as? UINavigationController {
            viewController = navigationController.viewControllers[0]
        }

        // Attach self as delegate to scan manager
        if  let scanViewController = viewController as? ScanViewController {
            scanViewController.delegate = self
        }
    }
}


// MARK: - Actions

extension MainViewController {
    
    @IBAction private func joystickControl_valueChanged(sender: CAJoystickControl) {
        
        // Convert joystick vector to speed
        let su = sender.value.toTankDrive
        let sl = Int16(su.left  * 255)
        let sr = Int16(su.right * 255)
        
        // Send command to device
        smartCar?.setSpeed(left: sl, right: sr)
        
        // Show set speed in UI
        speedSetLeftLabel.text  = "\(sl)"
        speedSetRightLabel.text = "\(sr)"
    }
    
    @IBAction private func sonarPing_touchUpInside(sender: UIButton) {
        smartCar?.sonarPing()
    }
}


// MARK: - Scan View Controller Delegate

extension MainViewController: ScanViewControllerDelegate {
    
    func scanViewController(viewController: ScanViewController, didConnectToPeripheral peripheral: BLESerialPeripheral) {
        smartCar = SmartCar(serialPeripheral: peripheral)
    }
}


// MARK: - Smart Car Delegate

extension MainViewController: SmartCarDelegate {
    
    func smartCarDidDisconnect(smartCar: SmartCar) {
        
        // Clear connected smart car
        self.smartCar = nil
        
        // Scan for smart car again
        performSegueWithIdentifier("ShowScanViewController", sender: nil)
    }
}
