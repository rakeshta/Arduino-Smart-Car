//
//  CGVector+Ext.swift
//  BLESmartCarRemote
//
//  Created by Rakesh TA on 5/03/2016.
//  Copyright © 2016 Raptor Soft. All rights reserved.
//

import CoreGraphics
import CocoaLumberjackSwift


private let Radians_45  = CGFloat(M_PI_4)
private let Radians_90  = CGFloat(M_PI_2)
private let Radians_135 = CGFloat(M_PI_2 + M_PI_4)
private let Radians_180 = CGFloat(M_PI)

extension CGVector {
    
    var toTankDrive: (left: CGFloat, right: CGFloat) {
        
        let scale: (angle: CGFloat, angleMin: CGFloat, angleMax: CGFloat, magMin: CGFloat, magMax: CGFloat) -> CGFloat = { angle, angleMin, angleMax, magMin, magMax in
            if  angle <= angleMin { return magMin }
            if  angle >= angleMax { return magMax }
            return magMin + (magMax - magMin) * (angle - angleMin) / (angleMax - angleMin)
        }
        
        var l   = 0.0 as CGFloat
        var r   = 0.0 as CGFloat
        
        let a   = angle
        let aa  = abs(a)
        if      aa >= 0.0         && aa < Radians_90 {
            l   = 1.0
            r   = scale(angle: aa, angleMin: 0.0,         angleMax: Radians_90,  magMin:  1,   magMax:  0)
        }
        else if aa >= Radians_90  && aa <  Radians_135 {
            l   = scale(angle: aa, angleMin: Radians_90,  angleMax: Radians_135, magMin:  1,   magMax: -1)
            r   = scale(angle: aa, angleMin: Radians_90,  angleMax: Radians_135, magMin:  0,   magMax: -0.5)
        }
        else if aa >= Radians_135 && aa <= Radians_180 {
            l   = -1.0
            r   = scale(angle: aa, angleMin: Radians_135, angleMax: Radians_180, magMin: -0.5, magMax: -1)
        }
        
        let m   = magnitude
        l      *= m
        r      *= m
        
        if  a   < 0.0 {
            swap(&l, &r)
        }
        
        return (l, r)
    }
    
    
    // See http://home.kendra.com/mauser/Joystick.html
    var toTankDrive2: (left: CGFloat, right: CGFloat) {
        let xp = dx * 100.0
        let yp = dy * 100.0
        let v  = (100.0 - fabs(xp)) * (yp / 100.0) + yp
        let w  = (100.0 - fabs(yp)) * (xp / 100.0) + xp
        let l  = (v + w) / 2.0
        let r  = (v - w) / 2.0
        return (l / 100.0, r / 100.0)
    }
}