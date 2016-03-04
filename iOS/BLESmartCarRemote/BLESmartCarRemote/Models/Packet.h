//
//  Packet.h
//  BLESmartCarRemote
//
//  Created by Rakesh TA on 3/3/16.
//  Copyright © 2016 Raptor Soft. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef struct {
    UInt8 start[2];
    UInt8 version;
    UInt8 padding;
    UInt8 payload[58];
    UInt8 end[2];
} Packet;
