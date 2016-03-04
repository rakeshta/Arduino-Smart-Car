//
//  Message.swift
//  BLESmartCarRemote
//
//  Created by Rakesh TA on 3/3/16.
//  Copyright © 2016 Raptor Soft. All rights reserved.
//

import Foundation


// MARK: - Message Type

extension Message {

    enum Type: UInt8 {
        case SetSpeed
    }
}


// MARK: - Message

internal struct Message {

    // MARK: - Members
    
    let type: Type
}