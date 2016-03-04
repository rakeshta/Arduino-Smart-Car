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
    case InvalidSize        = "Invalid size"
    case InvalidStartMarker = "Invalid start marker"
    case InvalidEndMarker   = "Invalid end marker"
    case InvalidVersion     = "Invalid version"
}


// MARK: - Constants

extension Packet {
    
    static let StartMarker0 = 0x01 as UInt8
    static let StartMarker1 = 0x02 as UInt8

    static let EndMarker0   = 0x0D as UInt8
    static let EndMarker1   = 0x0A as UInt8

    static let Version      = 0x01 as UInt8
}


// MARK: - Creation

extension Packet {
    
    init(type: PayloadType, @noescape configure: inout Payload -> Void) {
        self.start   = (Packet.StartMarker0, Packet.StartMarker1)
        self.version = Packet.Version
        self.type    = type
        self.payload = Payload()
        self.end     = (Packet.EndMarker0,   Packet.EndMarker1)

        configure(&payload)
    }
}


// MARK: - Serialization

extension Packet {
    
    var serialize: NSData {
        var copy = self
        return NSData(bytes: &copy, length: sizeof(Packet))
    }
    
    static func deserialize(data: NSData) throws -> Packet {
        
        // Ensure data is of right length
        if  data.length != sizeof(Packet) {
            throw PacketError.InvalidSize
        }
        
        // Verify header, footer & version
        do {
            let bytes = UnsafePointer<UInt8>(data.bytes)
            
            if  bytes[0] != StartMarker0 || bytes[1] != StartMarker1 {
                throw PacketError.InvalidStartMarker
            }
            
            if  bytes[2] != Version {
                throw PacketError.InvalidVersion
            }
            
            if  bytes[data.length - 2] != EndMarker0 || bytes[data.length - 1] != EndMarker1 {
                throw PacketError.InvalidEndMarker
            }
        }
        
        // Deserialize packet from data
        let pointer = UnsafeMutablePointer<Packet>.alloc(1)
        data.getBytes(pointer, length: data.length)
        
        return pointer.move()
    }
}

