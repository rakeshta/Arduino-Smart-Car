//
//  Packet.h
//  BLESmartCarRemote
//
//  Created by Rakesh TA on 3/03/2016.
//  Copyright © 2016 Raptor Soft. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(UInt8, PayloadType) {
    PayloadTypeSetSpeed = 0x01,
};

typedef struct {
    SInt16 left;
    SInt16 right;
} SpeedPayload;


typedef union {
    UInt8         bytes[10];
    SpeedPayload  speed;
} Payload;


typedef struct {
    UInt8        start[2];
    UInt8        version;
    PayloadType  type;
    Payload      payload;
    UInt8        end[2];
} Packet;
