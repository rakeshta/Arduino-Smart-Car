//
//  Packet.h
//  Created by Rakesh TA on 3/03/2016.
//
//  Packet structure used for communicating between the arduino sketch
//  and the iOS app. This file is shared between the two projects.
//

#include <stdint.h>

#ifndef __PACKET_H__
#define __PACKET_H__


typedef enum : uint8_t {
  PacketMarkerStart0   = 0x53,
  PacketMarkerStart1   = 0x54,
  PacketMarkerEnd0     = 0x0D,
  PacketMarkerEnd1     = 0x0A,
  PacketMarkerVersion  = 0x01,
} PacketMarker;


typedef enum : uint8_t {
    PayloadTypeSetSpeed  = 0x01,
    PayloadTypeSonarPing = 0x02,
} PayloadType;


typedef struct {
    int16_t       left;
    int16_t       right;
} SpeedPayload;

typedef union {
    uint8_t       bytes[10];
    SpeedPayload  speed;
} Payload;


typedef struct {
    PacketMarker  start[2];
    PacketMarker  version;
    PayloadType   type;
    Payload       payload;
    PacketMarker  end[2];
} Packet;


#endif // __PACKET_H__
