//
//  SmartCar.swift
//  BLESmartCarRemote
//
//  Created by Rakesh TA on 4/03/2016.
//  Copyright © 2016 Raptor Soft. All rights reserved.
//

import Foundation
import CocoaLumberjackSwift
import BLESerial


// MARK: - SmartCar

internal class SmartCar {
    
    // MARK: - Shared Serial Manager
    
    static let serialManager = BLESerialManager()
    
    
    // MARK: - Members
    
    let serialPeripheral: BLESerialPeripheral
    
    
    // MARK: - Init
    
    init(serialPeripheral: BLESerialPeripheral) {
        self.serialPeripheral = serialPeripheral
    }
}


// MARK: - Control Messages

extension SmartCar {
    
    func setSpeed(left left: Int16, right: Int16) {
        send(.SetSpeed) {
            $0.speed.left  = left
            $0.speed.right = right
        }
    }
    
    func sonarPing() {
        send(.SonarPing)
    }
    
    
    // MARK: -
    
    private func send(type: PayloadType) {
        send(type) { _ in }
    }
    
    private func send(type: PayloadType, @noescape configure: inout Payload -> Void) {
        let packet = Packet(type: type, configure: configure)
        serialPeripheral.writeData(packet.serialize)
        
        // DEBUG
        let toHex = { (data: NSData) -> String in
            let bytes = UnsafePointer<UInt8>(data.bytes)
            var str   = ""
            for i in 0 ..< data.length {
                str  += String(format: "0x%02x ", arguments: [bytes[i]])
            }
            return str
        }
        let hex = toHex(packet.serialize)
        DDLogVerbose("\(CurrentFileName()): Sent packet [\(hex)]")
//        if  let dat = "\n\(hex)]\n".dataUsingEncoding(NSUTF8StringEncoding) {
//            serialPeripheral.writeData(dat)
//        }
        // END DEBUG
    }
}