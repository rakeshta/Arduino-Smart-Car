//
//  SerialProcessor.h
//  Created by Rakesh TA on 04/03/16.
//
//  Component to serialize & deserialize packets.
//

#ifndef __SERIAL_PROCESSOR_H__
#define __SERIAL_PROCESSOR_H__

#include "Arduino.h"
#include "Packet.h"

class SerialProcessor {
private:
  static uint8_t nextExpectedByte();
  static void    processPacket(Packet *packet);
  
public:
  static void    begin();
  static void    loop();
};

#endif /* __SERIAL_PROCESSOR_H__ */
