//
//  ScanViewController.swift
//  BLE Smart Car Remote
//
//  Created by Rakesh TA on 21/02/2016.
//  Copyright © 2016 Raptor Soft. All rights reserved.
//

import UIKit
import BLESerial


// MARK: - ScanViewCell

internal final class ScanViewCell: UITableViewCell {
    
    // MARK: - Constants
    
    private static let Identifier = "ScanViewCell"
    
    
    // MARK: - IB Outlets
    
    @IBOutlet var nameLabel:    UILabel!
    @IBOutlet var detailLabel:  UILabel!
    
    
    // MARK: - Members
    
    private var peripheral: BLESerialPeripheral? {
        didSet {
            nameLabel.text   = peripheral?.name
            detailLabel.text = peripheral?.localName
        }
    }
}


// MARK: - ScanViewController

internal final class ScanViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet var tableView:               UITableView!
    @IBOutlet var scanningLabel:           UILabel!
    @IBOutlet var activityIndicatorView:   UIActivityIndicatorView!
    
    
    // MARK: - Members
    
    private var peripherals             = [BLESerialPeripheral]()
}


// MARK: - View Lifecycle

extension ScanViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Clear list of peripherals
        peripherals.removeAll()
        tableView.reloadData()
        
        // Update scanning label
        updateScanningLabel()
        
        // Start scanning
        RemoteController.sharedController.serialManager.scanDelegate = self
        RemoteController.sharedController.serialManager.startScan()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stop scanning
        RemoteController.sharedController.serialManager.stopScan()
        RemoteController.sharedController.serialManager.scanDelegate = nil
    }
}


// MARK: - Appearance

extension ScanViewController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}


// MARK: - Helpers

extension ScanViewController {
    
    private func updateScanningLabel() {
        scanningLabel.hidden = peripherals.count > 0
    }
    
    private func connectPeripheral(peripheral: BLESerialPeripheral) {
        
        // Prepare Ui
        view.userInteractionEnabled = false
        activityIndicatorView.startAnimating()
        
        // Connect
        peripheral.connect { success, error in
            
            // Restore UI
            self.view.userInteractionEnabled = true
            self.activityIndicatorView.startAnimating()
            
            // Save connected peripheral & dismiss self on success
            if  success {
                RemoteController.sharedController.connectedPeripheral = peripheral
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}



// MARK: - Table View Data Source & Delegate

extension ScanViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ScanViewCell.Identifier, forIndexPath: indexPath) as! ScanViewCell

        cell.peripheral = peripherals[indexPath.row]

        return cell
    }
    
    
    // MARK: -
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        connectPeripheral(peripherals[indexPath.row])
    }
}


// MARK: - BLE Serial Manager Scan Delegate

extension ScanViewController: BLESerialManagerScanDelegate {
    
    func serialManager(serialManager: BLESerialManager, didDiscoverPeripheral peripheral: BLESerialPeripheral) {
        
        // Add to list
        peripherals.append(peripheral)
        
        // Insert in UI
        let index     = peripherals.count - 1
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)

        // Update scanning label
        updateScanningLabel()
    }
}
