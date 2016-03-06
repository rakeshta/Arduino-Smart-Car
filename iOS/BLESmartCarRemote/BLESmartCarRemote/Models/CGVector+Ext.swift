//
//  CGVector+Ext.swift
//  BLESmartCarRemote
//
//  Created by Rakesh TA on 5/03/2016.
//  Copyright © 2016 Raptor Soft. All rights reserved.
//

import CoreGraphics
import CocoaLumberjackSwift


extension CGVector {
    
    // See http://home.kendra.com/mauser/Joystick.html
    var toTankDrive: (left: CGFloat, right: CGFloat) {
        let xp = dx * 100.0
        let yp = dy * 100.0
        let v  = (100.0 - fabs(xp)) * (yp / 100.0) + yp
        let w  = (100.0 - fabs(yp)) * (xp / 100.0) + xp
        let l  = (v + w) / 2.0
        let r  = (v - w) / 2.0
        return (l / 100.0, r / 100.0)
    }
}