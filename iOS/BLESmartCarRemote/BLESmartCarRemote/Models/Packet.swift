//
//  Packet.swift
//  BLESmartCarRemote
//
//  Created by Rakesh TA on 3/3/16.
//  Copyright © 2016 Raptor Soft. All rights reserved.
//

import Foundation


// MARK: - PacketError

internal enum PacketError: String, ErrorType {
    case InvalidSize    = "Invalid size"
    case InvalidHeader  = "Invalid header"
    case InvalidFooter  = "Invalid footer"
    case InvalidVersion = "Invalid version"
}


// MARK: - Constants

extension Packet {
    
    static let PaddingTop0    = 0x01 as UInt8
    static let PaddingTop1    = 0x02 as UInt8

    static let PaddingBottom0 = 0x0D as UInt8
    static let PaddingBottom1 = 0x0A as UInt8
    
    static let Version        = 0x01 as UInt8
}


// MARK: - Serialization

extension Packet {
    
    var toData: NSData {
        var copy = self
        return NSData(bytes: &copy, length: sizeof(Packet))
    }
    
    static func fromData(data: NSData) throws -> Packet {
        
        // Ensure data is of right length
        if  data.length != sizeof(Packet) {
            throw PacketError.InvalidSize
        }
        
        // Verify header, footer & version
        do {
            let bytes = UnsafePointer<UInt8>(data.bytes)
            
            if  bytes[0] != PaddingTop0 || bytes[1] != PaddingTop1 {
                throw PacketError.InvalidHeader
            }
            
            if  bytes[2] != Version {
                throw PacketError.InvalidVersion
            }
            
            if  bytes[data.length - 2] != PaddingBottom0 || bytes[data.length - 1] != PaddingBottom1 {
                throw PacketError.InvalidFooter
            }
        }
        
        // Deserialize packet from data
        let pointer = UnsafeMutablePointer<Packet>.alloc(1)
        data.getBytes(pointer, length: data.length)
        
        return pointer.move()
    }
}