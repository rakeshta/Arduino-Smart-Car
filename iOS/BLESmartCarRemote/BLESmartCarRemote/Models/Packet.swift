//
//  Packet.swift
//  BLESmartCarRemote
//
//  Created by Rakesh TA on 3/3/16.
//  Copyright © 2016 Raptor Soft. All rights reserved.
//

import Foundation


// MARK: - PayloadType

extension PayloadType {
    static let SetSpeed     = PayloadTypeSetSpeed
    static let SonarPing    = PayloadTypeSonarPing
}


// MARK: - PacketError

internal enum PacketError: String, ErrorType {
    case InvalidSize        = "Invalid size"
    case InvalidStartMarker = "Invalid start marker"
    case InvalidEndMarker   = "Invalid end marker"
    case InvalidVersion     = "Invalid version"
}


// MARK: - Creation

extension Packet {
    
    init(type: PayloadType, @noescape configure: inout Payload -> Void) {
        self.start   = (PacketMarkerStart0, PacketMarkerStart1)
        self.version = PacketMarkerVersion
        self.type    = type
        self.payload = Payload()
        self.end     = (PacketMarkerEnd0,   PacketMarkerEnd1)

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
            
            if  bytes[0] != PacketMarkerStart0.rawValue || bytes[1] != PacketMarkerStart1.rawValue {
                throw PacketError.InvalidStartMarker
            }
            
            if  bytes[2] != PacketMarkerVersion.rawValue {
                throw PacketError.InvalidVersion
            }
            
            if  bytes[data.length - 2] != PacketMarkerEnd0.rawValue || bytes[data.length - 1] != PacketMarkerEnd1.rawValue {
                throw PacketError.InvalidEndMarker
            }
        }
        
        // Deserialize packet from data
        let pointer = UnsafeMutablePointer<Packet>.alloc(1)
        data.getBytes(pointer, length: data.length)
        
        return pointer.move()
    }
}

