//
//  Packet.h
//  Created by Rakesh TA on 3/03/2016.
//
//  Packet structure used for communicating between the arduino sketch
//  and the iOS app. This file is shared between the two projects.
//

#include <stdint.h>

typedef enum : uint8_t {
    PayloadTypeSetSpeed = 0x01,
} PayloadType;

typedef struct {
    int16_t left;
    int16_t right;
} SpeedPayload;


typedef union {
    uint8_t       bytes[10];
    SpeedPayload  speed;
} Payload;


typedef struct {
    uint8_t      start[2];
    uint8_t      version;
    PayloadType  type;
    Payload      payload;
    uint8_t      end[2];
} Packet;
