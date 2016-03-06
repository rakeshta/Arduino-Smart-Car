//
//  SerialProcessor.cpp
//  Created by Rakesh TA on 04/03/16.
//
//  Component to serialize & deserialize packets.
//

#include <SoftwareSerial.h>
#include "SerialProcessor.h"
#include "SmartCar.h"
#include "Pins.h"

// Bluetoth serial
SoftwareSerial bleSerial(PIN_BLE_RX, PIN_BLE_TX); // RX, TX

// Incoming buffer
uint8_t blePacketBuf[sizeof(Packet)];
uint8_t blePacketBufIndex = 0;

// Begin serial com
void SerialProcessor::begin() {
  bleSerial.begin(9600);
}

// Loop
void SerialProcessor::loop() {

  // Abort if no data on serial port
  if (bleSerial.available() == 0) {
    return;
  }

  // Get the next expected & actual packets. If there is a mismatch,
  // reset the read and wait until we get the expected packet again.
  // The reset will also ensure that a buffer overlow does not occur.
  uint8_t expected = SerialProcessor::nextExpectedByte();
  uint8_t actual   = bleSerial.read();
  
  if (expected > 0 && expected != actual) {
    blePacketBufIndex = 0;
    return;
  }

  // Append byte to buffer
  blePacketBuf[blePacketBufIndex] = actual;
  blePacketBufIndex++;

  // If we have a complete packet, it's time to process it
  if (blePacketBufIndex >= sizeof(Packet)) {
    SerialProcessor::processPacket((Packet *)blePacketBuf);

    // Start over for next packet
    blePacketBufIndex = 0;
  }
}


// The next expected byte. Returns 0, if no expectation.
uint8_t SerialProcessor::nextExpectedByte() {
    switch (blePacketBufIndex) {
      case 0:                  return PacketMarkerStart0;
      case 1:                  return PacketMarkerStart1;
      case 2:                  return PacketMarkerVersion;
      case sizeof(Packet) - 2: return PacketMarkerEnd0;
      case sizeof(Packet) - 1: return PacketMarkerEnd1;
      default:                 return 0x00;
    }
}

// Interpret the packet & process it
void SerialProcessor::processPacket(Packet *packet) {
  switch (packet->type) {
    case PayloadTypeSetSpeed:
      SmartCar::setSpeed(packet->payload.speed.left, packet->payload.speed.right);
      break;

    case PayloadTypeSonarPing:
      SmartCar::sonarPing();
      break;
  }
}

